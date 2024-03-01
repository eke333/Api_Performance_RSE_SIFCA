from dbkeys import supabase
from utils_data import readDataJson
from flask_restful import Resource
from flask import request, make_response


class SuiviDataIndicateur(Resource):

    def updateSuiviIndicateur(self,entiteId, annee):

        try:
            suiviMap = {"indicateur_total": 280, "indicateur_valides": 0, "indicateur_collectes": 0,
                        "suivi_mensuel": {},"suivi_axe": {}}
            ########################
            entiteList = supabase.table('Entites').select("nom_entite").eq("id_entite", entiteId).execute().data
            #print(entiteList)
            nomEntite = entiteList[0]["nom_entite"]

            idSuivi = f"{entiteId}_{annee}"
            isExist = supabase.table('SuiviData').select("*").eq("id_suivi", idSuivi).execute().data

            if isExist == []:
                supabase.table('SuiviData').insert({
                    "id_suivi": idSuivi, "annee": annee,
                    "id_entite": entiteId, "nom_entite": nomEntite,
                }).execute()

            ########################

            dataValeurList = readDataJson(entiteId, f"{entiteId}_data_{annee}.json")
            dataValidationList = readDataJson(entiteId, f"{entiteId}_validation_{annee}.json")

            axesMap = {}

            dataAxe1 = []
            for rowData in dataValeurList:
                start = 16 -1
                end = 46
                kData = rowData[0]
                if kData != None:
                    dataAxe1.append(kData)
                axesMap["axe_1"] = {
                    "indicateur_total": (end-1)-start,
                    "indicateur_collectes": len(dataAxe1)
                }

            dataAxe2 = []
            for rowData in dataValeurList:
                start = 47 -1
                end = 206
                kData = rowData[0]
                if kData != None:
                    dataAxe2.append(kData)
                axesMap["axe_2"] = {
                    "indicateur_total": end-start,
                    "indicateur_collectes": len(dataAxe2)
                }

            dataAxe3 = []
            for rowData in dataValeurList:
                start = 207 -1
                end = 221
                kData = rowData[0]
                if kData != None:
                    dataAxe3.append(kData)
                axesMap["axe_3"] = {
                    "indicateur_total": end-start,
                    "indicateur_collectes": len(dataAxe3)
                }

            dataAxe4 = []
            for rowData in dataValeurList:
                start = 222 -1
                end = 280
                kData = rowData[0]
                if kData != None:
                    dataAxe4.append(kData)
                axesMap["axe_4"] = {
                    "indicateur_total": end-start,
                    "indicateur_collectes": len(dataAxe4)
                }

            suiviDataRealise = []

            for rowData in dataValeurList:
                kData = rowData[0]
                if kData != None:
                    suiviDataRealise.append(kData)

            suiviValidationRealise = []

            for rowData in dataValidationList:
                kValidation = rowData[0]
                if kValidation == True:
                    suiviValidationRealise.append(kValidation)

            suiviMensuel = {}
            for mois in range(1, 13):
                mapMois = {
                    "indicateur_valides": 0,
                    "indicateur_collectes": 0
                }
                ksuiviDataRealise = []

                for rowData in dataValeurList:
                    kData = rowData[mois]
                    if kData != None:
                        ksuiviDataRealise.append(kData)

                ksuiviValidationRealise = []

                for rowData in dataValidationList:
                    kValidation = rowData[mois]
                    if kValidation == True:
                        ksuiviValidationRealise.append(kValidation)

                mapMois["indicateur_collectes"] = len(ksuiviDataRealise)
                mapMois["indicateur_valides"] = len(ksuiviValidationRealise)

                suiviMensuel[f"{mois}"] = mapMois

            suiviMap["indicateur_total"] = len(dataValeurList)
            suiviMap["indicateur_collectes"] = len(suiviDataRealise)
            suiviMap["indicateur_valides"] = len(suiviValidationRealise)
            suiviMap["suivi_mensuel"] = suiviMensuel
            suiviMap["suivi_axe"] = axesMap

            supabase.table('SuiviData').update(suiviMap).eq('id_suivi', idSuivi).execute()

            return True
        except:
            return False

    def post(self):
        args = request.get_json()

        annee = args["annee"]
        entite = args["entite"]

        self.updateSuiviIndicateur(entite,annee)


        return {"status":True}