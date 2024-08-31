from flask import request, jsonify
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
    libelle = data.get('libelle')
    id_axe = data.get('id_axe')
    type_enjeu = data.get('type_enjeu', '')  # Ajouter un type_enjeu si nécessaire

    if not libelle or not id_axe:
        return jsonify({"error": "libelle and id_axe are required"}), 400

    try:
        response = supabase.from_("EnjeuTable").insert({
            "libelle": libelle,
            "id_axe": id_axe,
            "type_enjeu": type_enjeu
        }).execute()

        if response.status_code == 201:
            return jsonify({"message": "Enjeu added successfully"}), 201
        else:
            return jsonify({"error": "Failed to add enjeu"}), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500
