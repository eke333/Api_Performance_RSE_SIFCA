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


@main_routes.route('/check_id_enjeu_exists', methods=['GET', 'POST'])
def check_id_enjeu_exists_route():
    return check_id_enjeu_exists()


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


"""----------------------------------------------Suppressions(delete)-----------------------------------------------"""

@main_routes.route('/delete_opportunite/<int:id_opportunite>', methods=['DELETE'])
def delete_opportunite_route(id_opportunite):
    return delete_opportunite(id_opportunite)


@main_routes.route('/delete_risque/<int:id_opportunite>', methods=['DELETE'])
def delete_risque_route(id_opportunite):
    return delete_opportunite(id_opportunite)


"""----------------------------------------------Modifications(update)----------------------------------------------"""


@main_routes.route('/update-text', methods=['POST', 'GET'])
def update_text_route():
    return update_text()


@main_routes.route('/update_opportunite/<int:id_opportunite>', methods=['PUT'])
def update_opportunite_route(id_risque):
    return update_risque(id_risque)


@main_routes.route('/update_risque/<int:id_risque>', methods=['PUT'])
def update_risque_route(id_risque):
    return update_risque(id_risque)


"""-----------------------------------------------------------------------------------------------------------------"""
