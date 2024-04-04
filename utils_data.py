import json
import os
from supabase import create_client

url = "https://djlcnowdwysqbrggekme.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqbGNub3dkd3lzcWJyZ2dla21lIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIxNzc1NjcsImV4cCI6MjAwNzc1MzU2N30.UxvLKjDhQ4ghsGTTY7Sy1Q75YCktx2nXR2pHuLeIMF4"
supabase = create_client(url, key)

def saveDataInJson(dataList,entite,fileName):
    directory_path = f'donnees/{entite}'
    if not os.path.exists(directory_path):
        os.makedirs(directory_path)

    file_path = os.path.join(directory_path,fileName)

    json_data = json.dumps(dataList)
    with open(file_path, 'w') as file:
        file.write(json_data)

def readDataJson(entite, fileName):
    directory_path = f'donnees/{entite}'
    file_path = os.path.join(directory_path, fileName)

    if not os.path.exists(file_path):
        return None

    with open(file_path, 'r') as file:
        json_data = file.read()

    return json.loads(json_data)


annees = [2021,2022,2023,2024,2025,2026]
ligne = [None,None,None,None,None,None,None,None,None,None,None,None,None]


def dataListGen() :
    list = []
    for i in range(288):
        list.append(ligne)
    return list
