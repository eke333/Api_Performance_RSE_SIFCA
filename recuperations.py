from flask import Flask, jsonify
from dbkeys import supabase

def get_urgences():
    try:
        response = supabase.table('Urgences') \
            .select('nom_urgence', 'poids_urgence') \
            .order('poids_urgence', desc=True) \
            .order('nom_urgence', desc=False) \
            .execute()

        return jsonify(response.data)

    except Exception as e:
        print(f"Exception: {e}")
        return jsonify({'error': str(e)}), 500
