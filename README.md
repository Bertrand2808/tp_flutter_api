# **ESGI - Application de Connexion**

## **Description**
Cette application est un projet Flutter qui permet aux utilisateurs de se connecter et de consulter leur profil grâce à une interface utilisateur.

L'API backend est développée en Python avec la bibliothèque Flask et une base de données PostgreSQL pour la gestion des utilisateurs.

---
## Démonstration

Vous trouverez une vidéo démonstration du projet dans `assets/Démonstration.mkv`

![alt text](assets/files.png)

## **Prérequis**
### **Backend**
- Python 3.10 ou version ultérieure
- PostgreSQL installé et configuré
- Bibliothèques Python nécessaires (spécifiées dans `server.py`) :
  - Flask
  - Flask-CORS
  - Flask-SQLAlchemy
  - bcrypt
  - jwt
  - marshmallow

### **Frontend**
- Flutter SDK (version 3.5.3 ou ultérieure)
- Un éditeur de texte ou IDE compatible Flutter (VSCode, Android Studio, etc.)

---

## **Installation**
### **1. Configuration de la base de données PostgreSQL**
1. Ouvrez un terminal `SQL Shell`

    ![alt text](assets/sql.png)

    Cela vous demandera plusieurs choses :
    ```bash
      Server [localhost]:
      Database [postgres]:
      Port [5432]:
      Username [postgres]:
      Mot de passe pour l'utilisateur postgres :
    ```

    - **Server :** localhost
    - **Database :** postgres
    - **Port :** 5432
    - **Username :** postgres
    - **Mot de passe :** Entrez le mot de passe que vous avez défini lors de l'installation de PostgreSQL

    Vous devriez voir quelque chose comme ceci :
    ```bash
    postgres=#
    ```

2. Créez une base de données PostgreSQL nommée `auth_db` :
   ```sql
   CREATE DATABASE auth_db;
   ```

   Puis taper `\c auth_db` pour rentrer dans la base de données PostgreSQL.

3. Connectez-vous à la base de données et créez la table `users` :
   ```sql
   CREATE TABLE users (
       id SERIAL PRIMARY KEY,
       email VARCHAR(255) UNIQUE NOT NULL,
       password_hash VARCHAR(255) NOT NULL,
       first_name VARCHAR(100) NOT NULL,
       last_name VARCHAR(100) NOT NULL,
       role VARCHAR(50) NOT NULL
   );
   ```

   Vous devriez voir quelque chose comme ceci :
   ```bash
   CREATE TABLE
   ```

---

### **2. Installation du backend**
1. Clonez ce projet ou téléchargez les fichiers.
2. Installez les dépendances Python :
   ```bash
   pip install flask flask-cors flask-sqlalchemy bcrypt pyjwt marshmallow
   ```
3. Configurez la connexion PostgreSQL dans le fichier `server.py` :
   ```python
   app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://<votre_utilisateur>:<votre_mot_de_passe>@localhost:5432/auth_db'
   ```

   Par exemple :
    ```python
    app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:password@localhost:5432/auth_db'
    ```

4. Lancez le serveur :
   ```bash
   python server.py
   ```

5. Générer les utilisateurs :
    ```bash
    curl -X POST http://localhost:5000/init_users
    ```

    ou dans un navigateur :
    ```bash
    http://localhost:5000/init_users
    ```

    Vous devriez voir quelque chose comme ceci :
    ```bash
    {
        "message": "Utilisateurs créés avec succès !"
    }
    ```

    ![alt text](assets/table_user.png)
---

### **3. Installation du frontend**
1. Assurez-vous que Flutter est correctement configuré :
   ```bash
   flutter doctor
   ```
2. Installez les dépendances Flutter définies dans `pubspec.yaml` :
   ```bash
   flutter pub get
   ```

3. Lancez l'application Flutter :
   ```bash
   flutter run
   ```

---

## **Fonctionnalités**
### **1. Authentification**
- Connexion des utilisateurs avec un email et un mot de passe.
- Gestion sécurisée des mots de passe (hachage avec bcrypt).
- Utilisation de tokens JWT pour l'authentification.

### **2. Profil utilisateur**
- Affichage des informations utilisateur (nom, prénom, email, rôle).
- Possibilité de se déconnecter.

### **3. Réactivité et esthétique**
- Interface utilisateur moderne avec Flutter.
- Responsive design pour différentes tailles d'écran.

---

## **Endpoints de l'API**
### **1. `/login`**
- **Méthode :** `POST`
- **Description :** Authentifie un utilisateur avec son email et son mot de passe.
- **Exemple de requête :**
  ```json
  {
    "email": "user@example.com",
    "password": "userpass"
  }
  ```
  ou
  
  ```json
   {
      "email": "admin@example.com",
      "password": "adminpass"
   }
   ```
- **Exemple de réponse :**
  ```json
  {
    "token": "<JWT_token>",
    "user": {
      "email": "user@example.com",
      "first_name": "Jane",
      "last_name": "Doe",
      "role": "User"
    }
  }
  ```


### **2. `/init_users`**
- **Méthode :** `POST`
- **Description :** Crée des utilisateurs initiaux dans la base de données.


---

## **Arborescence du projet**
```
.
├── assets/
│   └── logo.png
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   └── profile_screen.dart
│   └── services/
│       └── auth_service.dart
├── server.py
├── pubspec.yaml
└── README.md
```

---

## **Languages**
- **Frontend :** Développé avec Flutter.
- **Backend :** Développé avec Flask et PostgreSQL.

---

## **Images**

![alt text](assets/page_login.png)
![alt text](assets/loading.png)
![alt text](assets/profile.png)

---

## **Auteurs**
- **Auteur :** [Bertrand](https://github.com/Bertrand2808)
