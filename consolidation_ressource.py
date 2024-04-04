import pprint
import time
from datetime import datetime

from flask_restful import Resource
from flask import request

from dbkeys import supabase
from utils import PerformGlobal, indexes_by
from utils_data import  readDataJson, saveDataInJson, dataListGen

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

        #Algo recup valeurs validees
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
    
    def computePerformEntity(self, entite, dataValeurListN1, annee):
        id = f"{entite}_{annee}"

        dataValeurListN2 = readDataJson(entite,f"{entite}_data_{annee - 1}.json")
        responseListEcart = supabase.table('DataIndicateur').select("ecarts").eq("id", id).execute().data
        responseListAxesEnjeu = supabase.table('Indicateurs').select("axe, enjeu").order("numero",desc= False).execute().data
        dicTemp = responseListEcart[0]
        listEcart = dicTemp['ecarts']

        # indicesListAxes = [16, 46, 206, 221, 280]
        # indicesListEnjeux = [16, 21, 27, 34, 46, 181, 200, 206, 221, 245, 262, 280]
        listAxes = []
        listEnjeux = []

        for i, (rowN1, rowN2) in enumerate (zip(dataValeurListN1, dataValeurListN2)):
            dataRealiseN1 = rowN1[0]
            dataRealiseN2 = rowN2[0]

            if dataRealiseN2 != None and dataRealiseN1 != None:
                dataEcart = ((dataRealiseN2 - dataRealiseN1) / dataRealiseN2) * 100
                listEcart[i] = dataEcart
        
        #Calcul de la performance Globale
        globalPerfData = PerformGlobal(listEcart)

        def extract_data(response_list, list_ecart, value):
            """Extracts data from response_list based on value and calculates average."""
            result_list = []
            list_index = indexes_by(response_list, value=value)
            for index_list in list_index:
                temp_list = []
                for index in index_list:
                    temp_list.append(list_ecart[index])
                result_list.append(temp_list)
            for index, item in enumerate(result_list):
                l = []
                count = 0
                for data in item:
                    if data != None:
                        l.append(data)
                        count += 1
                if l != []:
                    result_list[index] = sum(l) / count
                else:
                    result_list[index] = None
            return result_list

        resultlistAxes = extract_data(responseListAxesEnjeu, listEcart, "axe")
        listAxes = resultlistAxes[1:]
        resultlistEnjeux = extract_data(responseListAxesEnjeu, listEcart, "enjeu")
        listEnjeux = resultlistEnjeux[1:]

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
        self.scriptConsolidation(annee, consolidationFiliere)
        time.sleep(1)
        #self.scriptConsolidation(annee, consolidationGroupe)
        time.sleep(1)
        print(datetime.now())
        return {'status': True}
