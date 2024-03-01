import pprint
import time
from datetime import datetime

from flask_restful import Resource
from flask import request

from dbkeys import supabase
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
        response = supabase.table('AccesPilotage').select('email, entite, Users(nom)').eq("est_editeur", True).execute().data #test recup email
        # #print(response)
        dictionnaire_utilisateurs = {}

        for utilisateur in response:
            email = utilisateur['email']
            #print(email)
            entite = utilisateur['entite']
            #print(entite)
            noms = [user['nom'] for user in utilisateur['Users']]
            dictionnaire_utilisateurs[email] = (noms, entite)

        print(dictionnaire_utilisateurs)

        id = f"{entite}_{annee}"

        response = supabase.table('DataIndicateur').select("*").eq("id", id).execute().data
        data = response[0]

        dataValeurList = data["valeurs"]
        
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
                print(f"Données consolidées : {consoEntite}")
            except:
                result = dataListGen()
                self.updateAllEntiteDataMatrice(consoEntite, result, annee)

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
