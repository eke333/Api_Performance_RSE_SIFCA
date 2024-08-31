from flask import Blueprint
from ajouts import add_urgence
from recuperations import *
from modifications import update_text

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


"""----------------------------------------------Ajouts(add)--------------------------------------------------------"""


@main_routes.route('/ajouter_urgence', methods=['POST', 'GET'])
def add_urgence_route():
    return add_urgence()


@main_routes.route('/add_enjeu', methods=['POST', 'GET'])
def add_enjeu_route():
    return add_enjeu_route()


"""----------------------------------------------Suppressions(delete)-----------------------------------------------"""

"""----------------------------------------------Modifications(update)----------------------------------------------"""


@main_routes.route('/update-text', methods=['POST', 'GET'])
def update_text_route():
    return update_text()


"""-----------------------------------------------------------------------------------------------------------------"""
