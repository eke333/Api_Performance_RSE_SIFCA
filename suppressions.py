import uuid

from flask import jsonify
from dbkeys import supabase


def delete_opportunite(id_opportunite):
    response = supabase.table('Opportunites').delete().eq('id_opportunite', id_opportunite).execute()

    if response.data is None:
        print("Erreur lors de la suppression")
        return jsonify({"error": "Erreur lors de la suppression"}), 400

    print("Opportunité supprimée avec succès", f"id_opportunite = {id_opportunite}")

    return jsonify({"message": "Opportunité supprimée avec succès", "id_opportunite": id_opportunite}), 200


def delete_risque(id_risque):
    response = supabase.table('Risques').delete().eq('id_risque', id_risque).execute()

    if response.data is None:
        print("Erreur lors de la suppression")
        return jsonify({"error": "Erreur lors de la suppression"}), 400

    print("Risque supprimé avec succès", f"id_risque = {id_risque}")

    return jsonify({"message": "Risque supprimé avec succès", "id_opportunite": id_risque}), 200


def delete_alea(id):
    try:
        response = supabase.table('Aleas').delete().eq('id_alea', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return {"error": "Failed to delete danger", "details": str(e)}, 500


def delete_impact(id):
    try:
        response = supabase.table('Impacts').delete().eq('id_impact', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return {"error": "Failed to delete incident", "details": str(e)}, 500


def delete_aspect_environnemental(id):
    try:
        response = supabase.table('AspectsEnv').delete().eq('id_aspect_env', id).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return {"error": "Failed to delete incident", "details": str(e)}, 500


# Route pour supprimer une modification
def delete_modification_matrice_RACI(id):
    try:
        # Vérifier si l'identifiant est un UUID valide
        uuid.UUID(id)
    except ValueError:
        return jsonify({"error": "Identifiant UUID invalide"}), 400

    try:
        response = supabase.table('TableModifications').delete().eq('id', id).execute()
        if response.count == 0:
            return jsonify({"error": "Modification non trouvée"}), 404
        return jsonify({"message": "Modification supprimée avec succès"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
