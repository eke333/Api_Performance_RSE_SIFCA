from flask import Flask, render_template
from flask_cors import CORS
from flask_restful import Api, Resource
from flask_talisman import Talisman

from routes import main_routes  # Importer le Blueprint
import os

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = int(os.getenv('MAX_CONTENT_LENGTH', 15 * 1024 * 1024))

api = Api(app)

# Configurer CORS pour autoriser toutes les origines.
CORS(app, resources={r"/*": {"origins": "*"}})

# Assurer la sécurité HTTPS en production avec Talisman
if os.getenv('FLASK_ENV') == 'production':
    Talisman(app)

# Enregistrer le Blueprint avec l'application
app.register_blueprint(main_routes)


@app.route('/')
def welcome():
    return render_template('index.html')


# Détection de l'environnement (en Production ou en Développement

if os.getenv('FLASK_ENV') == 'production':
    # Paramètres de production
    app.config['DEBUG'] = False
else:
    # Paramètres de développement
    app.config['DEBUG'] = True

if __name__ == '__main__':
    app.run()  # Par défaut le port en production sur render est 10000, et en local c'est 5000.
