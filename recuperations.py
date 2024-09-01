from flask import Flask, jsonify, request
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
        response = supabase.table('AxeTable').select('id_axe, libelle').execute()
        return jsonify(response.data)
    except Exception as e:
        return jsonify({"Erreur de récupération de axes": str(e)}), 500


def check_id_enjeu_exists():
    try:
        id_enjeu = request.args.get('id_enjeu')
        response = supabase.table('EnjeuTable').select('id_enjeu').eq('id_enjeu', id_enjeu).execute()
        exists = len(response.data) > 0
        return jsonify({'exists': exists})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

