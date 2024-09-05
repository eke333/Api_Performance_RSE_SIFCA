from flask import request, jsonify
from dbkeys import supabase

TABLE_NAME = 'Urgences'


def update_text():
    data = request.json
    id = data.get('id')
    new_text = data.get('libelle')

    try:
        if not id or not new_text:
            return jsonify({'error': 'Invalid data'}), 400

        response = supabase.table('FonctionGenerale').update({'libelle': new_text}).eq('id', id).execute()
        return jsonify({'message': 'Text updated successfully'})
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def update_text_budgets():
    data = request.json
    id = data.get('id')
    new_text = data.get('libelle')

    try:
        if not id or not new_text:
            return jsonify({'error': 'Invalid data'}), 400

        response = supabase.table('Budgets').update({'libelle': new_text}).eq('id', id).execute()
        return jsonify({'message': 'Text updated successfully'})
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def update_text_domaines():
    data = request.json
    id = data.get('id')
    new_text = data.get('libelle')

    try:
        if not id or not new_text:
            return jsonify({'error': 'Invalid data'}), 400

        response = supabase.table('DomainesDapplication').update({'libelle': new_text}).eq('id', id).execute()
        return jsonify({'message': 'Text updated successfully'})
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def update_text_perimetres():
    data = request.json
    id = data.get('id')
    new_text = data.get('libelle')

    try:
        if not id or not new_text:
            return jsonify({'error': 'Invalid data'}), 400

        response = supabase.table('PerimetresDapplication').update({'libelle': new_text}).eq('id', id).execute()
        return jsonify({'message': 'Text updated successfully'})
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def update_text_exclusions():
    data = request.json
    id = data.get('id')
    new_text = data.get('libelle')

    try:
        if not id or not new_text:
            return jsonify({'error': 'Invalid data'}), 400

        response = supabase.table('Exclusions').update({'libelle': new_text}).eq('id', id).execute()
        return jsonify({'message': 'Text updated successfully'})
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def update_opportunite(id_opportunite):
    try:
        # Récupération des données JSON de la requête
        data = request.json
        if not data or 'libelle' not in data:
            print("Données JSON manquantes ou clé 'libelle' absente")
            return jsonify({"error": "Données JSON manquantes ou clé 'libelle' absente"}), 400

        nouveau_libelle = data['libelle']

        # Mise à jour dans Supabase
        response = supabase.table('Opportunites').update({'libelle': nouveau_libelle}).eq('id_opportunite',
                                                                                          id_opportunite).execute()
        print("Opportunité mise à jour avec succès", f"{id_opportunite}")
        return jsonify({"message": "Opportunité mise à jour avec succès", "id_opportunite": id_opportunite}), 200

    except Exception as e:
        # Gestion des exceptions
        print(f"Exception lors de la mise à jour: {e}")
        return jsonify({"error": "Une erreur est survenue lors de la mise à jour"}), 500


def update_risque(id_risque):
    try:
        # Récupération des données JSON de la requête
        data = request.json
        if not data or 'libelle' not in data:
            print("Données JSON manquantes ou clé 'libelle' absente")
            return jsonify({"error": "Données JSON manquantes ou clé 'libelle' absente"}), 400

        nouveau_libelle = data['libelle']

        # Mise à jour dans Supabase
        response = supabase.table('Risques').update({'libelle': nouveau_libelle}).eq('id_risque',
                                                                                     id_risque).execute()
        print("Opportunité mise à jour avec succès", f"{id_risque}")
        return jsonify({"message": "Opportunité mise à jour avec succès", "id_risque": id_risque}), 200

    except Exception as e:
        # Gestion des exceptions
        print(f"Exception lors de la mise à jour: {e}")
        return jsonify({"error": "Une erreur est survenue lors de la mise à jour"}), 500


def update_alea(id):
    try:
        data = request.json
        response = supabase.table('Aleas').update({'libelle': data['libelle']}).eq('id_alea', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return jsonify({"error": "Failed to update danger"}), 500


def update_impact(id):
    try:
        data = request.json
        response = supabase.table('Impacts').update({'libelle': data['libelle']}).eq('id_impact', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return jsonify({"error": "Failed to update danger"}), 500


def update_aspect_environnemental(id):
    try:
        data = request.json
        response = supabase.table('AspectsEnv').update({'libelle': data['libelle']}).eq('id_aspect_env', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return jsonify({"error": "Failed to update danger"}), 500
