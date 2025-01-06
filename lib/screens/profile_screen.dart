import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  ProfileScreen({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Profil de l\'Utilisateur'),
    actions: [
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          // Action de déconnexion
          Navigator.pop(context);
        },
      ),
    ],
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Affichage des informations du profil
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nom'),
              subtitle: Text('$firstName $lastName'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Rôle'),
              subtitle: Text(role),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Déconnexion en retournant à l'écran de connexion
                Navigator.pop(context);
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}