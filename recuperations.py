from flask import Flask, jsonify, request
from dbkeys import supabase


def get_text():
    response = supabase.table('FonctionGenerale').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_budgets():
    response = supabase.table('Budgets').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_domaines():
    response = supabase.table('DomainesDapplication').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_perimetres():
    response = supabase.table('PerimetresDapplication').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_exclusions_perimetres():
    response = supabase.table('Exclusions').select('id, libelle').eq('type', 'perimetre').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_exclusions_domaines():
    response = supabase.table('Exclusions').select('id, libelle').eq('type', 'domaine').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_plan_d_action():
    response = supabase.table('PlanDaction').select('id, libelle').execute()
    print(response)
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_text_non_conformites_et_actions_de_maitrise():
    response = supabase.table('NonConformitesEtActionsCorrectives').select('id, libelle').execute()
    data = response.data
    if data:
        return jsonify(data[0])
    else:
        return jsonify({'error': 'No data found'}), 404


def get_enjeux():
    try:
        response = supabase.table('EnjeuContexte').select('*').order('libelle', desc=False).execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def get_risques():
    try:
        response = supabase.table('Risques').select('*').order('libelle', desc=False).execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def get_opportunites():
    try:
        response = supabase.table('Opportunites').select('*').order('libelle', desc=False).execute()
        if response.data:
            return jsonify(response.data)
        else:
            return jsonify({'error': 'No data found'}), 404
    except Exception as e:
        # Retourne une erreur générique en cas d'exception
        return jsonify({'error': 'An unexpected error occurred', 'message': str(e)}), 500


def get_axes():
    try:
        response = supabase.table('AxeTable').select('id_axe, libelle').order('libelle', desc=False).execute()
        return jsonify(response.data)
    except Exception as e:
        return jsonify({"Erreur de récupération de axes": str(e)}), 500


def get_dangers():
    response = supabase.table('Aleas').select('*').gt('poids_incident_danger', 5).order('poids_incident_danger',
                                                                                        desc=True).order('libelle',
                                                                                                         desc=False).execute()
    return jsonify(response.data)


def get_incidents():
    response = supabase.table('Aleas').select('*').lte('poids_incident_danger', 5).order('poids_incident_danger',
                                                                                         desc=True).order('libelle',
                                                                                                          desc=False).execute()
    return jsonify(response.data)


def get_impacts_environnementaux():
    response = supabase.table('Impacts').select('*').gt('degre_impact', 5).order('degre_impact', desc=True).order(
        'libelle', desc=False).execute()
    return jsonify(response.data)


def get_impacts_societaux():
    response = supabase.table('Impacts').select('*').lte('degre_impact', 5).order('degre_impact', desc=True).order(
        'libelle', desc=False).execute()
    return jsonify(response.data)


def get_aspects_environnementaux():
    response = supabase.table('AspectsEnv').select('*').order('gravite_impact', desc=True).order('libelle',
                                                                                                 desc=False).execute()
    return jsonify(response.data)


# Obtenir toutes les modifications de la matrice RACI
def get_modifications_matrice_RACI():
    try:
        response = supabase.table('TableModifications').select('*').execute()
        return jsonify(response.data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def get_parties_interessees():
    try:
        # Requête à Supabase
        response = supabase.table('PartiesInteressees').select('*').order('libelle', desc=False).execute()

        if response.data is not None:
            # Convertir les données en liste de dictionnaires
            parties_list = [dict(partie) for partie in response.data]

            # Retourner les données au format JSON
            return jsonify(parties_list)
        else:
            return jsonify({'error': 'Erreur lors de la récupération des données'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500


def get_processus():
    try:
        response = supabase.from_('Processus').select('*').execute()
        data = response.data
        if data:
            return jsonify({'processus': data}), 200
        else:
            return jsonify({'message': 'Aucun processus trouvé'}), 404
    except Exception as e:
        return jsonify({'message': 'Erreur lors de la récupération des processus', 'error': str(e)}), 500


def check_id_enjeu_exists():
    try:
        id_enjeu = request.args.get('id_enjeu')
        print(f"id_enjeu = {id_enjeu}", "\n")
        response = supabase.table('EnjeuTable').select('id_enjeu').eq('id_enjeu', id_enjeu).execute()
        print(f"response = {response.data}", "\n")
        exists = len(response.data) > 0
        print(f"existe = {exists}")
        print(len(response.data))
        return jsonify({'exists': exists})

    except Exception as e:
        print("Je rentre dans l'exception ")
        return jsonify({"error": str(e)}), 500
