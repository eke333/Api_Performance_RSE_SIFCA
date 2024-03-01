from flask_restful import Resource
from flask import request, make_response
import copy
from data import calculated_keys
from dbkeys import supabase
from utils import formuleCalcules, formuleSomme, formuleDernierMois, formuleMoyenne, PerformGlobal
from utils_data import readDataJson, saveDataInJson

class GetDataEntiteIndicateur(Resource):
    # Appel des données indicateurs
    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]

        dataValeurList = readDataJson(entite,f"{entite}_data_{annee}.json")
        dataValidationList = readDataJson(entite, f"{entite}_validation_{annee}.json")


        return {"entite":entite,"annee":annee,"valeurs":dataValeurList,"validations": dataValidationList}

class UpdateDataEntiteIndicateur(Resource):
    # Mise à jour des données indicateurs
    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]
        colonne = args["colonne"]
        ligne = args["ligne"]
        valeur = args["valeur"]
        type = args["type"]
        formule = args["formule"]

        id = f"{entite}_{annee}"

        responseListEcart = supabase.table('DataIndicateur').select("ecarts").eq("id", id).execute().data
        dicTemp = responseListEcart[0]
        listEcart = dicTemp['ecarts']
        responseDataCible = supabase.table('DataIndicateur').select("cibles").eq("id", id).execute().data
        dataTemp = responseDataCible[0]
        dataList = dataTemp['cibles']
        dataCible = dataList[ligne]

        indicesListAxes = [16, 46, 206, 221, 280]
        indicesListEnjeux = [16, 21, 27, 34, 46, 181, 200, 206, 221, 245, 262, 280]

        listAxes = []
        listEnjeux = []

        dataValeurList = readDataJson(entite,f"{entite}_data_{annee}.json")
        dataValidationList = readDataJson(entite, f"{entite}_validation_{annee}.json")

        isValide = dataValidationList[ligne][colonne]

        if isValide == True :
            return  {"status":False,"message":"La donnée est déja validée"}

        dataValeurList[ligne][colonne] = valeur

        # Formule Colonne "Réalisé" ligne primaire

        if type == "Primaire" :

            if formule == "Somme" :
                listTemp = copy.deepcopy(dataValeurList[ligne])
                listCalcul = listTemp[1:]
                sommeList = formuleSomme(listCalcul)
                if sommeList != None:
                    dataValeurList[ligne][0] = sommeList
                    if dataCible != None:
                        dataEcart = ((dataCible - sommeList) / dataCible) * 100
                        listEcart[ligne] = dataEcart

            elif formule == "Dernier mois renseigné" :
                listTemp = copy.deepcopy(dataValeurList[ligne])
                listCalcul = listTemp[1:]
                dernierMoisList = formuleDernierMois(listCalcul)
                if dernierMoisList != None:
                    dataValeurList[ligne][0] = dernierMoisList
                    if dataCible != None:
                        dataEcart = ((dataCible - dernierMoisList) / dataCible) * 100
                        listEcart[ligne] = dataEcart

            elif formule == "Moyenne" :
                listTemp = copy.deepcopy(dataValeurList[ligne])
                listCalcul = listTemp[1:]
                moyenneList = formuleMoyenne(listCalcul)
                if moyenneList != None:
                    dataValeurList[ligne][0] = moyenneList
                    if dataCible != None:
                        dataEcart = ((dataCible - moyenneList) / dataCible) * 100
                        listEcart[ligne] = dataEcart

        # Formule Colonne ligne calculés
        for index in calculated_keys :

            dataRow = formuleCalcules(index, dataValeurList)
            if dataRow != None:
                dataValeurList[index - 1] = dataRow

        #Calcul de la performance Globale
        globalPerfData = PerformGlobal(listEcart)

        #decoupage de listEcart pous definir listes des Axes pour performances Axes
        for i in range(len(indicesListAxes) - 1):
            axeList = listEcart[indicesListAxes[i]:indicesListAxes[i + 1]]
            listAxes.append(axeList)
        for index, item in enumerate(listAxes):
            l = []
            count = 0
            for data in item:
                if data != None:
                    l.append(data)
                    count += 1
            if l != [] :
                listAxes[index] = sum(l) / count
            else:
                listAxes[index] = None

        #decoupage de listEcart pous definir listes des Enjeux pour performances Enjeux
        for i in range(len(indicesListEnjeux) - 1):
            enjeuList = listEcart[indicesListEnjeux[i]:indicesListEnjeux[i + 1]]
            listEnjeux.append(enjeuList)
        for index, item in enumerate(listEnjeux):
            l = []
            count = 0
            for data in item:
                if data != None:
                    l.append(data)
                    count += 1
            if l != [] :
                listEnjeux[index] = sum(l) / count
            else:
                listEnjeux[index] = None

        
        supabase.table('Performance').update({'performs_piliers': listAxes}).eq('id',id).execute()
        supabase.table('Performance').update({'performs_enjeux': listEnjeux}).eq('id',id).execute()
        supabase.table('Performance').update({'performs_global': globalPerfData}).eq('id', id).execute()

        saveDataInJson(dataValeurList,entite,f"{entite}_data_{annee}.json")
        supabase.table('DataIndicateur').update({'valeurs': dataValeurList}).eq('id',id).execute()
        supabase.table('DataIndicateur').update({"ecarts" : listEcart}).eq('id',id).execute()

        return {"status":True}

class ComputePerformsEntite(Resource):
    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]
        colonne = args["colonne"]
        ligne = args["ligne"]
        valeurCible = args["datacible"]
        type = args["type"]
        formule = args["formule"]

        id = f"{entite}_{annee}"

        responseListEcart = supabase.table('DataIndicateur').select("ecarts").eq("id", id).execute().data
        dicTemp = responseListEcart[0]
        listEcart = dicTemp['ecarts']
        responseRealise = supabase.table('DataIndicateur').select("valeurs").eq("id", id).execute().data
        dicTemp = responseRealise[0]
        listValeurs = dicTemp['valeurs']
        dataRealise = listValeurs[ligne][0]

        indicesList = [16, 46, 207, 222, 280]
        indicesListEnjeux = [16, 21, 27, 34, 46, 181, 200, 206, 221, 245, 262, 280]

        listAxes = []
        listEnjeux = []

        if type == "Primaire":

            if formule == "Somme":
                if dataRealise != None:
                    dataEcart = ((valeurCible - dataRealise) / valeurCible) * 100
                    listEcart[ligne] = dataEcart
            
            elif formule == "Dernier mois renseigné":
                if dataRealise != None:
                    dataEcart = ((valeurCible - dataRealise) / valeurCible) * 100
                    listEcart[ligne] = dataEcart

            elif formule == "Moyenne":
                if dataRealise != None:
                    dataEcart = ((valeurCible - dataRealise) / valeurCible) * 100
                    listEcart[ligne] = dataEcart

        globalPerfData = PerformGlobal(listEcart)

        #decoupage de listEcart pous definir listes des Axes pour performances
        for i in range(len(indicesList) - 1):
            axeList = listEcart[indicesList[i]:indicesList[i + 1]]
            listAxes.append(axeList)
        for index, item in enumerate(listAxes):
            l = []
            count = 0
            for data in item:
                if data != None:
                    l.append(data)
                    count += 1
            if l != [] :
                listAxes[index] = sum(l) / count
            else:
                listAxes[index] = None

        #decoupage de listEcart pous definir listes des Enjeux pour performances Enjeux
        for i in range(len(indicesListEnjeux) - 1):
            enjeuList = listEcart[indicesListEnjeux[i]:indicesListEnjeux[i + 1]]
            listEnjeux.append(enjeuList)
        for index, item in enumerate(listEnjeux):
            l = []
            count = 0
            for data in item:
                if data != None:
                    l.append(data)
                    count += 1
            if l != [] :
                listEnjeux[index] = sum(l) / count
            else:
                listEnjeux[index] = None
        
        supabase.table('Performance').update({'performs_piliers': listAxes}).eq('id',id).execute()
        supabase.table('Performance').update({'performs_enjeux': listEnjeux}).eq('id',id).execute()
        supabase.table('Performance').update({'performs_global': globalPerfData}).eq('id', id).execute()
        supabase.table('DataIndicateur').update({"ecarts" : listEcart}).eq('id',id).execute()

        return {"status":True}

class UpdateAllDataEntiteIndicateur(Resource):
    # Mise à jour des données indicateurs
    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]
        dataValeurList = args["valeurs"]
        dataValidationsList = args["validations"]

        saveDataInJson(dataValeurList,entite,f"{entite}_data_{annee}.json")
        saveDataInJson(dataValidationsList, entite, f"{entite}_validation_{annee}.json")

        return {"status":True}

class UpdateDataEntiteIndicateurFromSupabase(Resource):
    # Mise à jour des données indicateurs
    def post(self):

        args = request.get_json()

        id = args["id"]

        response = supabase.table('DataIndicateur').select("*").eq("id",id).execute().data
        data = response[0]

        entite = data["entite"]
        annee = data["annee"]
        dataValeurList = data["valeurs"]
        dataValidationsList = data["validations"]

        saveDataInJson(dataValeurList,entite,f"{entite}_data_{annee}.json")
        saveDataInJson(dataValidationsList, entite, f"{entite}_validation_{annee}.json")

        return {"status":True}

class UpdateValidationEntiteIndicateur(Resource):
    # Mise à jour des données indicateurs
    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]
        colonne = args["colonne"]
        ligne = args["ligne"]
        valide = args["valide"]

        id = f"{entite}_{annee}"


        dataValidationsList = readDataJson(entite,f"{entite}_validation_{annee}.json")
        dataValidationsList[ligne][colonne] = valide
        saveDataInJson(dataValidationsList,entite,f"{entite}_validation_{annee}.json")
        supabase.table('DataIndicateur').update({'validations': dataValidationsList}).eq('id', id).execute()

        return {"status":True}

class EntiteExportAllData(Resource):

    def getRealise(self,dataValeurs):
        result = []
        for data in dataValeurs :
            result.append(data[0])
        return result

    def getJson(self,start,end,dataEntite,dataRealise):
        kList = []
        for i in range(start - 1, end - 1):
            kDoc = {
                    "numero": i + 1,
                    "reference": dataEntite[i]["reference"],
                    "intitule": dataEntite[i]["intitule"],
                    "unite": dataEntite[i]["unite"],
                    "realise": dataRealise[i]
                }
            kList.append(kDoc)
        return kList

    def post(self):
        args = request.get_json()
        try :

            annee = args["annee"]
            entiteId = args["entiteId"]

            ###################################

            kEntite = supabase.table("Entites").select("*").eq("id_entite", entiteId).execute()
            dataEntite = kEntite.data[0]

            filiale = dataEntite["filiale"]
            entiteName = dataEntite["nom_entite"]
            color = dataEntite["couleur"]

            id = f"{entiteId}_{annee}"
            response = supabase.table('DataIndicateur').select("*").eq("id", id).execute().data
            data = response[0]
            dataValeurList = data["valeurs"]

            dataRealise = self.getRealise(dataValeurList)

            #################################

            kIndicateur = supabase.table("Indicateurs").select("*").execute()
            dataEntite = kIndicateur.data

            ## Général

            allRows = self.getJson(1,280,dataEntite,dataRealise)

            return {
                "entreprise": "Groupe SIFCA",
                "filiale": f"{filiale}",
                "entite": f"{entiteName}",
                "annee": annee,
                "color":color,
                "data": allRows
            }
        except :
            return make_response({"status":False},404)