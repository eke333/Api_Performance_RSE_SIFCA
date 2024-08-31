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
