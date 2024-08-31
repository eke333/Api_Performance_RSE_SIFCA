from flask import Flask
from flask_cors import CORS
from flask_restful import Api, Resource
from routes import main_routes  # Importer le Blueprint

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 15 * 1024 * 1024  # Limiter la taille des fichiers téléchargés

api = Api(app)

# Configurer CORS pour autoriser toutes les origines.
CORS(app, resources={r"/*": {"origins": "*"}})

# Enregistrer le Blueprint avec l'application
app.register_blueprint(main_routes)

class HelloWorld(Resource):
    def get(self):
        return {
            'version': '1.2.0',
            'infoApi': "Je suis l'API principale pour le projet performance QSE",
        }

# Ajouter HelloWorld au routeur API
api.add_resource(HelloWorld, '/')

if __name__ == '__main__':
    # Pour un serveur local non sécurisé (HTTP)
    app.run(debug=True, port=5000, host="0.0.0.0")
