import 'package:flutter/material.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Service d'authentification'
  // Tableau associatif des utilisateurs
  final Map<String, Map<String, dynamic>> _users = {
    'user@example.com': {
      'password': 'userpass',
      'firstName': 'Jane',
      'lastName': 'Doe',
      'role': 'User',
    },
    'admin@example.com': {
      'password': 'adminpass',
      'firstName': 'Admin',
      'lastName': 'User',
      'role': 'Admin',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Aligne les éléments sur toute la largeur
              children: <Widget>[
                // Champ de saisie de l'email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Format de l\'email incorrect. Essayez "exemple@domaine.com".';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Champ de saisie du mot de passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Bouton ou indicateur de chargement
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  bool _isLoading = false;
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      final user = await _authService.login(email, password);
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        // Connexion réussie avec informations supplémentaires
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(
                  email: email,
                  firstName: _users[email]!['firstName'],
                  lastName: _users[email]!['lastName'],
                  role: _users[email]!['role'],
                ),
          ),
        );
      } else {
        // Connexion échouée
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Erreur'),
                content: Text('Email ou mot de passe incorrect'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }
}
