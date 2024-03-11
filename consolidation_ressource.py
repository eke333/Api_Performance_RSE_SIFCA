import pprint
import time
from datetime import datetime

from flask_restful import Resource
from flask import request

from dbkeys import supabase
from utils import PerformGlobal
from utils_data import  saveDataInJson, dataListGen

consolidationFiliale = {
    "sucrivoire": ["sucrivoire-siege", "sucrivoire-borotou-koro", "sucrivoire-zuenoula"],
    #"grel": ["grel-tsibu","grel-apimenim"],
    #"saph": ["saph-siege","saph-bettie","saph-bongo","saph-loeth","saph-ph-cc",
    #         "saph-rapides-grah","saph-toupah","saph-yacoli"],
    #"palmci":["palmci-siege","palmci-blidouba","palmci-boubo","palmci-ehania","palmci-gbapet",
    #    "palmci-iboke","palmci-irobo","palmci-neka","palmci-toumanguie"],
}
consolidationFiliere = {
    "sucre": ["sucrivoire"],
    "oleagineux": ["palmci", "sania", "mopp"],
    "caoutchouc-naturel": ["siph","crc","renl","saph","grel"],

}
consolidationGroupe = {
    "groupe-sifca": ["sucre","oleagineux","caoutchouc-naturel","sifca-holding"],
    "comex":["groupe-sifca"]
}

class ScriptConsolidation(Resource) :
    lengthDataList = 0

    def entiteDataMatrice(self,entite,annee):

        id = f"{entite}_{annee}"

        response = supabase.table('DataIndicateur').select("*").eq("id", id).execute().data
        data = response[0]
        dataValeurList = data["valeurs"]
        dataValidationList = data["validations"]
        
        #test
        # responseDatasIndic = supabase.table('Indicateurs').select("formule").execute().data
        # listTemp = [data["formule"] for data in responseDatasIndic]
        # dicTemp = responseDatasIndic[0]
        # print(listTemp)

        #Algo filtre des valeurs que validees
        listZip = list(zip(dataValeurList, dataValidationList))
        listResult = []
        max_length = max(len(sublist) for sublist in dataValeurList)

        for sublist, flags in listZip:
            temp = [sublist[i] if flags[i] else None for i in range(max_length)]
            listResult.append(temp)
        
        dataValeurList = listResult

        
        ScriptConsolidation.lengthDataList = len(dataValeurList)

        return dataValeurList

    def formuleSomme(self,list):
        l = []
        for data in list:
            if data != None:
                l.append(data)
        if l != []:
            return sum(l)
        return None

    def sumList(self,dataList):
        resultList = []
        for i in range(13):
            temp = []
            for list in dataList:
                temp.append(list[i])
            result = self.formuleSomme(temp)
            resultList.append(result)

        return resultList

    def getMatriceConso(self,children):
        matriceConso = []
        for i in range(ScriptConsolidation.lengthDataList):
            list = []
            for child in children:
                list.append(child[i])
            consoLigne = self.sumList(list)
            matriceConso.append(consoLigne)
        return matriceConso

    def updateAllEntiteDataMatrice(self,entite,dataValeurList,annee):

        id = f"{entite}_{annee}"
        supabase.table('DataIndicateur').update({'valeurs': dataValeurList}).eq('id', id).execute()
        saveDataInJson(dataValeurList, entite, f"{entite}_data_{annee}.json")


    def scriptConsolidation(self,annee,typeConso):
        for consoEntite, values in typeConso.items():
            try:
                children = []
                for entity in values:
                    child = self.entiteDataMatrice(entity,annee)
                    children.append(child)
                result = self.getMatriceConso(children)
                self.updateAllEntiteDataMatrice(consoEntite,result,annee)
                self.computePerformEntity(consoEntite, result, annee)
                print(f"Données consolidées : {consoEntite}")
            except:
                result = dataListGen()
                self.updateAllEntiteDataMatrice(consoEntite, result, annee)
    
    def computePerformEntity(self, entite, dataValeurList, annee):
        id = f"{entite}_{annee}"
        #print(entite)
        responseListEcart = supabase.table('DataIndicateur').select("ecarts").eq("id", id).execute().data
        responseDataCible = supabase.table('DataIndicateur').select("cibles").eq("id", id).execute().data
        responseFormules = supabase.table('Indicateurs').select('formule').execute().data
        responseTypes = supabase.table('Indicateurs').select('type').execute().data
        listTypes = [data["type"] for data in responseTypes]
        #print(listTypes)
        listFormules = [data["formule"] for data in responseFormules]
        #print(listFormules)
        dicTemp = responseListEcart[0]
        listEcart = dicTemp['ecarts']
        #print(listEcart)
        dataTemp = responseDataCible[0]
        listCible = dataTemp['cibles']
        #print(listCible)

        indicesListAxes = [16, 46, 206, 221, 280]
        indicesListEnjeux = [16, 21, 27, 34, 46, 181, 200, 206, 221, 245, 262, 280]
        listAxes = []
        listEnjeux = []

        for i, type_value in enumerate(listTypes):
            if type_value == 'Primaire':
                formule = listFormules[i]
                dataCible = listCible[i]
                dataRealise = dataValeurList[i][0]
                #print(dataRealise)
                
                if formule == "Somme":
                    if dataCible != None and dataRealise != None:
                        dataEcart = ((dataCible - dataRealise) / dataCible) * 100
                        listEcart[i] = dataEcart
                
                elif formule == "Dernier mois renseigné":
                        if dataCible != None and dataRealise != None:
                            dataEcart = ((dataCible - dataRealise) / dataCible) * 100
                            listEcart[i] = dataEcart
                
                elif formule == "Moyenne":
                        if dataCible != None and dataRealise != None:
                            dataEcart = ((dataCible - dataRealise) / dataCible) * 100
                            listEcart[i] = dataEcart
        
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
        supabase.table('DataIndicateur').update({"ecarts" : listEcart}).eq('id',id).execute()


    def post(self):
        args = request.get_json()

        annee = args["annee"]
        print(datetime.now())
        self.scriptConsolidation(annee,consolidationFiliale)
        time.sleep(1)
        #self.scriptConsolidation(annee, consolidationFiliere)
        time.sleep(1)
        #self.scriptConsolidation(annee, consolidationGroupe)
        time.sleep(1)
        print(datetime.now())
        return {'status': True}
