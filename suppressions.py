from flask import jsonify
from dbkeys import supabase

# TABLE_NAME = 'Urgences'
#
# def delete_urgence(id):
#     response = supabase.table(TABLE_NAME).delete().eq('id', id).execute()
#
#     if response.status_code == 200:
#         return jsonify({'message': 'Urgence supprimée avec succès'})
#     else:
#         return jsonify({'error': 'Erreur lors de la suppression de l\'urgence'}), response.status_code
