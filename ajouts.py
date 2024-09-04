import time
import uuid
from datetime import datetime

from flask import request, jsonify
from supabase._async.client import SupabaseException

from dbkeys import supabase


def add_urgence():
    data = request.json
    nom_urgence = data.get('nom_urgence')
    poids_urgence = data.get('poids_urgence')

    if not nom_urgence or poids_urgence not in [0.25, 0.5, 0.75, 1.0]:
        return jsonify({'message': 'Nom ou poids de l\'urgence invalide'}), 400

    try:
        # Insérer l'urgence dans la base de données Supabase
        response = supabase.table('Urgences').insert({
            'nom_urgence': nom_urgence,
            'poids_urgence': poids_urgence,
        }).execute()

        # Vérifiez si l'insertion a été réussie
        if response.data:
            return jsonify({'message': 'Urgence ajoutée avec succès'}), 201
        else:
            return jsonify({'message': 'Erreur lors de l\'ajout de l\'urgence', 'details': response}), 400
    except Exception as e:
        return jsonify({'message': f'Erreur serveur : {str(e)}'}), 500


def add_enjeu():
    data = request.json
    id_enjeu = data.get('id_enjeu')
    libelle = data.get('libelle')
    id_axe = data.get('id_axe')
    type_enjeu = data.get('type_enjeu')

    if not id_enjeu or not libelle or not id_axe:
        return jsonify({"error": "id_enjeu, libelle, and id_axe are required"}), 400

    try:
        response = supabase.from_("EnjeuTable").insert({
            "id_enjeu": id_enjeu,
            "libelle": libelle,
            "id_axe": id_axe,
            "type_enjeu": type_enjeu
        }).execute()

        if response.data:  # Si des données sont retournées, l'insertion a réussi
            print("insertion réussie")
            return jsonify({"message": "Enjeu added successfully"}), 201
        else:
            return jsonify({"error": "Failed to add enjeu"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def add_risque():
    data = request.json
    try:
        new_risque = {
            "gravite": int(data['gravite']),
            "libelle": data['libelle'],
            "id_enjeu": data['id_enjeu'],
            "frequence": float(data['frequence'])
        }
        response = supabase.table('Risques').insert(new_risque).execute()
        return jsonify({"message": "Risque ajouté avec succès", "data": response.data}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def add_opportunite():
    data = request.json
    try:
        new_risque = {
            "libelle": data['libelle'],
            "id_enjeu": data['id_enjeu'],
            "gravite": int(data['gravite']),
            "frequence": float(data['frequence'])
        }
        response = supabase.table('Opportunites').insert(new_risque).execute()
        return jsonify({"message": "Risque ajouté avec succès", "data": response.data}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def add_incident_ou_danger():
    try:
        data = request.json
        if not data:
            raise ValueError('No JSON data provided.')

        nom = data.get('libelle')
        poids = data.get('poids_incident_danger')

        if nom is None or poids is None:
            raise ValueError('Missing required fields: libelle or poids_incident_danger.')

        # Insérer les données dans la table Aleas
        response = supabase.table('Aleas').insert({
            'libelle': nom,
            'poids_incident_danger': poids
        }).execute()

        return jsonify({'message': 'Urgence ajoutée avec succès!'}), 200

    except ValueError as ve:
        return jsonify({'error': str(ve)}), 400
    except Exception as e:
        return jsonify({'error': 'Une erreur est survenue : ' + str(e)}), 500


def add_impact_environnemental_ou_societal():
    try:
        data = request.json
        if not data:
            raise ValueError('No JSON data provided.')

        nom = data.get('libelle')
        degre_impact = data.get('degre_impact')

        if nom is None or degre_impact is None:
            raise ValueError('Missing required fields: libelle or poids_incident_danger.')

        response = supabase.table('Impacts').insert({
            'libelle': nom,
            'degre_impact': degre_impact
        }).execute()

        return jsonify({'message': 'Urgence ajoutée avec succès!'}), 200

    except ValueError as ve:
        return jsonify({'error': str(ve)}), 400
    except Exception as e:
        return jsonify({'error': 'Une erreur est survenue : ' + str(e)}), 500


def add_aspect_environnemental():
    try:
        data = request.json
        if not data:
            raise ValueError('No JSON data provided.')

        nom = data.get('libelle')
        gravite_impact = data.get('gravite_impact')

        if nom is None or gravite_impact is None:
            raise ValueError('Missing required fields: libelle or poids_incident_danger.')

        response = supabase.table('AspectsEnv').insert({
            'libelle': nom,
            'gravite_impact': gravite_impact
        }).execute()

        return jsonify({'message': 'Urgence ajoutée avec succès!'}), 200

    except ValueError as ve:
        return jsonify({'error': str(ve)}), 400
    except Exception as e:
        return jsonify({'error': 'Une erreur est survenue : ' + str(e)}), 500


# Modification de la de la matrice RACI
def add_modification_matrice_RACI():
    data = request.get_json()

    row_index = data.get('row_index')
    column_index = data.get('column_index')
    cell_value = data.get('cell_value')

    if row_index is None or column_index is None or cell_value is None:
        return jsonify({"error": "Données manquantes"}), 400

    try:
        # Vérifiez si une modification existe déjà pour cette cellule
        existing_modification = supabase.table('TableModifications') \
            .select('id') \
            .eq('row_index', row_index) \
            .eq('column_index', column_index) \
            .execute()

        if existing_modification.data:
            # Mise à jour de la modification existante
            supabase.table('TableModifications') \
                .update({"cell_value": cell_value, "timestamp": "now()"}) \
                .eq('id', existing_modification.data[0]['id']) \
                .execute()
        else:
            # Ajout d'une nouvelle modification
            new_modification = {
                "row_index": row_index,
                "column_index": column_index,
                "cell_value": cell_value
            }
            supabase.table('TableModifications').insert(new_modification).execute()

        return jsonify({"message": "Modification enregistrée avec succès"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def add_row():
    data = request.json
    row_number = data['row_number']  # Numéro de la ligne
    row_data = data['row_data']      # Liste des données de la ligne
    default_cell_value = "Vide"

    try:
        # Pour chaque cellule de la ligne, insérer une entrée dans la table des modifications
        for column_index, cell_value in enumerate(row_data):
            if cell_value != None and cell_value != "":  # Vérifier si la cellule contient une valeur
                new_modification = {
                    "id": str(uuid.uuid4()),
                    "row_index": row_number,
                    "column_index": column_index,
                    "cell_value": cell_value,
                    "timestamp": datetime.utcnow().isoformat()
                }
                response = supabase.table("TableModifications").insert(new_modification).execute()
                print("Insersion de ligne réussie")
                return jsonify({'success': False, 'error': response.json()}), 201
            else:
                cell_value = default_cell_value
                new_modification = {
                    "id": str(uuid.uuid4()),
                    "row_index": row_number,
                    "column_index": column_index,
                    "cell_value": cell_value,
                    "timestamp": datetime.utcnow().isoformat()
                }
                time.sleep(2)
                response = supabase.table("TableModifications").insert(new_modification).execute()
                print("Insertion d'une ligne contenant la chaîne: 'Vide'")
                return jsonify({'success': False, 'error': response.json()}), 201

        print("Toutes les lignes sont insérées")
        return jsonify({'success': True}), 201

    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500
