from flask import jsonify
from dbkeys import supabase


def delete_opportunite(id_opportunite):
    response = supabase.table('Opportunites').delete().eq('id_opportunite', id_opportunite).execute()

    if response.data is None:
        print("Erreur lors de la suppression")
        return jsonify({"error": "Erreur lors de la suppression"}), 400

    print("Opportunité supprimée avec succès", "id_opportunite")

    return jsonify({"message": "Opportunité supprimée avec succès", "id_opportunite": id_opportunite}), 200


def delete_risque(id_risque):
    response = supabase.table('Risques').delete().eq('id_risque', id_risque).execute()

    if response.data is None:
        print("Erreur lors de la suppression")
        return jsonify({"error": "Erreur lors de la suppression"}), 400

    print("Opportunité supprimée avec succès", "id_opportunite")

    return jsonify({"message": "Opportunité supprimée avec succès", "id_opportunite": id_risque}), 200
