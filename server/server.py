from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import bcrypt
import jwt
from datetime import datetime, timedelta, timezone
from marshmallow import Schema, fields, ValidationError

SECRET_KEY = "your_secret_key" # Clé secrète pour les sessions
class LoginSchema(Schema):
  email = fields.Email(required=True)
  password = fields.Str(required=True)
def generate_token(user):
  # Génération d'un token JWT avec les informations de l'utilisateur
  token_payload = {
    'id': user.id,
    'email': user.email,
    'first_name': user.first_name,
    'last_name': user.last_name,
    'expires_in': (datetime.now(tz=timezone.utc) + timedelta(hours=1)).isoformat()
  }
  return jwt.encode(token_payload, SECRET_KEY, algorithm='HS256')

def verify_token(token):
  # Vérification du token JWT
  try:
    decoded_token = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    return decoded_token
  except jwt.ExpiredSignatureError:
    return None
  except jwt.InvalidTokenError:
    return None


# Configuration de Flask et de SQLAlchemy
app = Flask(__name__) # Création de l'application Flask
CORS(app) # Activation de CORS pour l'application
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:azerty@localhost:5432/auth_db' # Configuration de la base de données
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # Désactivation du suivi des modifications

db = SQLAlchemy(app) # Création de l'objet SQLAlchemy pour la base de données

with app.app_context():
  try:
    db.create_all() # Création des tables si elles n'existent pas
  except Exception as e:
    print(f"Erreur lors de la création des tables: {e}")

# Modèle d'utilisateur
class User(db.Model):
  __tablename__ = 'users' # Nom de la table
  id = db.Column(db.Integer, primary_key=True) # Clé primaire
  email = db.Column(db.String(255), unique=True, nullable=False) # Nom d'utilisateur unique
  password_hash = db.Column(db.String(255), nullable=False) # Mot de passe haché
  first_name = db.Column(db.String(100), nullable=False) # Prénom
  last_name = db.Column(db.String(100), nullable=False) # Nom
  role = db.Column(db.String(50), nullable=False) # Rôle

# Route pour initialiser la base des utilisateurs
@app.route('/init_users', methods=['POST'])
def init_users():
  try:
    users = [
      {
        "email": "user@example.com", "password": "userpass", "first_name": "Jane", "last_name": "Doe", "role": "user"
      },
      {
        "email": "admin@example.com", "password": "adminpass", "first_name": "John", "last_name": "Doe", "role": "admin"
      }
    ]

    for user in users:
      hashed_password = bcrypt.hashpw(user['password'].encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
      user = User(
        email=user['email'],
        password_hash=hashed_password,
        first_name=user['first_name'],
        last_name=user['last_name'],
        role=user['role']
      )
      db.session.add(user)
    db.session.commit()
    return jsonify({"message": "Succès : Utilisateurs créés."}), 201
  except Exception as e:
    return jsonify({"message": f"Erreur : {str(e)}"}), 500

# Route pour authentifier un utilisateur
@app.route('/login', methods=['POST'])
def login():
  schema = LoginSchema()
  # Vérification des données de la requête JSON
  try:
    data = schema.load(request.get_json())
  except ValidationError as e:
    return jsonify({"message": f"Erreur : {str(e)}"}), 400

  # Renvoie en cas d'absence de données
  if not data:
    return jsonify({"message": "Erreur : Corps de la requête JSON manquant"}), 400

  # Vérification des identifiants de l'utilisateur
  email = data.get('email')
  password = data.get('password')
  user = User.query.filter_by(email=email).first()

  if user and bcrypt.checkpw(password.encode('utf-8'), user.password_hash.encode('utf-8')):
    token = generate_token(user)
    return jsonify({
          "token": token,
          "user": {
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "role": user.role
          }
        }), 200
  else:
    return jsonify({"message": "Erreur : Identifiants incorrects."}), 401

# Route pour récupérer les informations de l'utilisateur

@app.route('/me', methods=['GET'])
def get_user_info():
  user_id = request.args.get('user_id')
  user = User.query.get(user_id)
  if user:
    return jsonify({
      "id": user.id,
      "username": user.username,
      "first_name": user.first_name,
      "last_name": user.last_name,
      "role": user.role
    }), 200
  else:
    return jsonify({"message": "Erreur : Utilisateur non trouvé."}), 404

if __name__ == '__main__':
  app.run(debug=True)
