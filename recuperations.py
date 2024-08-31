from flask import Flask, jsonify
from dbkeys import supabase

def get_text():
    response = supabase.table('FonctionGenerale').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_enjeux():
    try:
        response = supabase.table('EnjeuTable').select('*').execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500

def get_risques():
    try:
        response = supabase.table('Risques').select('*').execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500

def get_opportunites():
    try:
        response = supabase.table('Opportunites').select('*').execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def get_axes():
    try:
        response = supabase.from_("AxeTable").select("id_axe, libelle").order("libelle", desc=False).execute()
        return jsonify(response.data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

