from flask import Blueprint
from ajouts import *
from recuperations import *
from modifications import *
from suppressions import *

# Créez un Blueprint pour les routes
main_routes = Blueprint('main_routes', __name__)

"""----------------------------------------------Récupérations(get)-------------------------------------------------"""


@main_routes.route('/get-text', methods=['GET', 'POST'])
def get_text_route():
    return get_text()


@main_routes.route('/get-text-budgets', methods=['GET', 'POST'])
def get_text_budgets_route():
    return get_text_budgets()


@main_routes.route('/get-text-domaines', methods=['GET', 'POST'])
def get_text_domaines_route():
    return get_text_domaines()


@main_routes.route('/get-text-perimetres', methods=['GET', 'POST'])
def get_text_perimetres_route():
    return get_text_perimetres()


@main_routes.route('/get-text-exclusions-domaines', methods=['GET', 'POST'])
def get_text_exclusions_domaines_route():
    return get_text_exclusions_domaines()


@main_routes.route('/get-text-exclusions-perimetres', methods=['GET', 'POST'])
def get_text_exclusions_perimetres_route():
    return get_text_exclusions_perimetres()


@main_routes.route('/enjeux', methods=['GET', 'POST'])
def get_enjeux_route():
    return get_enjeux()


@main_routes.route('/opportunites', methods=['POST', 'GET'])
def get_opportunites_route():
    return get_opportunites()


@main_routes.route('/risques', methods=['GET', 'POST'])
def get_risques_route():
    return get_risques()


@main_routes.route('/get_axes', methods=['GET', 'POST'])
def get_axes_route():
    return get_axes()


@main_routes.route('/get_dangers', methods=['GET', 'POST'])
def get_dangers_route():
    return get_dangers()


@main_routes.route('/get_incidents', methods=['GET', 'POST'])
def get_incidents_route():
    return get_incidents()


@main_routes.route('/get_impacts_environnementaux', methods=['GET', 'POST'])
def get_impacts_environnementaux_route():
    return get_impacts_environnementaux()


@main_routes.route('/get_impacts_societaux', methods=['GET', 'POST'])
def get_impacts_societaux_route():
    return get_impacts_societaux()


@main_routes.route('/get_aspects_environnementaux', methods=['GET', 'POST'])
def get_aspects_environnementaux_route():
    return get_aspects_environnementaux()


# Route pour obtenir toutes les modifications de la matrice RACI
@main_routes.route('/modifications_matrice_RACI', methods=['GET'])
def get_modifications_matrice_RACI_route():
    return get_modifications_matrice_RACI()


@main_routes.route('/parties_interessees', methods=['GET'])
def get_parties_interessees_route():
    return get_parties_interessees()

@main_routes.route('/check_id_enjeu_exists', methods=['GET', 'POST'])
def check_id_enjeu_exists_route():
    return check_id_enjeu_exists()


@main_routes.route('/processus', methods=['GET'])
def get_processus_route():
    return get_processus()


"""----------------------------------------------Ajouts(add)--------------------------------------------------------"""


@main_routes.route('/ajouter_urgence', methods=['POST', 'GET'])
def add_urgence_route():
    return add_urgence()


@main_routes.route('/add_enjeu', methods=['POST', 'GET'])
def add_enjeu_route():
    return add_enjeu()


@main_routes.route('/add_risque', methods=['POST', 'POST'])
def add_risque_route():
    return add_risque()


@main_routes.route('/add_opportunite', methods=['POST', 'GET'])
def add_opportunite_route():
    return add_opportunite()


@main_routes.route('/ajouter_incident_ou_danger', methods=['POST'])
def add_incident_ou_danger_route():
    return add_incident_ou_danger()


@main_routes.route('/ajouter_impact_environnemental_ou_societal', methods=['POST'])
def add_impact_environnemental_ou_societal_route():
    return add_impact_environnemental_ou_societal()


@main_routes.route('/ajouter_aspect_environnemental', methods=['POST'])
def add_aspect_environnemental_route():
    return add_aspect_environnemental()


@main_routes.route('/modifications_matrice_RACI', methods=['POST'])
def add_modification_matrice_RACI_route():
    return add_modification_matrice_RACI()


@main_routes.route('/ajout_ligne_matrice_RACI', methods=['POST'])
def add_row_route():
    return add_row()


@main_routes.route('/ajouter_processus', methods=['POST'])
def add_processus_route():
    return add_processus()


"""----------------------------------------------Suppressions(delete)-----------------------------------------------"""


@main_routes.route('/delete_opportunite/<int:id_opportunite>', methods=['DELETE'])
def delete_opportunite_route(id_opportunite):
    return delete_opportunite(id_opportunite)


@main_routes.route('/delete_risque/<int:id_risque>', methods=['DELETE'])
def delete_risque_route(id_risque):
    return delete_risque(id_risque)


@main_routes.route('/delete_alea/<int:id>', methods=['DELETE'])
def delete_alea_route(id):
    return delete_alea(id)


@main_routes.route('/delete_impact/<int:id>', methods=['DELETE'])
def delete_impact_route(id):
    return delete_impact(id)


@main_routes.route('/delete_aspect_environnemental/<int:id>', methods=['DELETE'])
def delete_aspect_environnemental_route(id):
    return delete_aspect_environnemental(id)


# Route pour supprimer une modification
@main_routes.route('/modifications_matrice_RACI/<string:id>', methods=['DELETE'])
def delete_modification_matrice_RACI_route(id):
    return delete_modification_matrice_RACI(id)


"""----------------------------------------------Modifications(update)----------------------------------------------"""


@main_routes.route('/update-text', methods=['POST', 'GET'])
def update_text_route():
    return update_text()


@main_routes.route('/update-text-budgets', methods=['POST', 'GET'])
def update_text_budgets_route():
    return update_text_budgets()


@main_routes.route('/update-text-domaines', methods=['POST', 'GET'])
def update_text_domaines_route():
    return update_text_domaines()


@main_routes.route('/update-text-perimetres', methods=['POST', 'GET'])
def update_text_perimetres_route():
    return update_text_perimetres()


@main_routes.route('/update-text-exclusions-domaines', methods=['POST', 'GET'])
def update_text_exclusions_domaines_route():
    return update_text_exclusions()


@main_routes.route('/update-text-exclusions-perimetres', methods=['POST', 'GET'])
def update_text_exclusions_perimetres_route():
    return update_text_exclusions()


@main_routes.route('/update_opportunite/<int:id_opportunite>', methods=['PUT'])
def update_opportunite_route(id_opportunite):
    return update_opportunite(id_opportunite)


@main_routes.route('/update_risque/<int:id_risque>', methods=['PUT'])
def update_risque_route(id_risque):
    return update_risque(id_risque)


@main_routes.route('/update_alea/<int:id>', methods=['PUT'])
def update_alea_route(id):
    return update_alea(id)


@main_routes.route('/update_impact/<int:id>', methods=['PUT'])
def update_impact_route(id):
    return update_impact(id)


@main_routes.route('/update_aspect_environnemental/<int:id>', methods=['PUT'])
def update_aspect_environnemental_route(id):
    return update_aspect_environnemental(id)


"""-----------------------------------------------------------------------------------------------------------------"""
