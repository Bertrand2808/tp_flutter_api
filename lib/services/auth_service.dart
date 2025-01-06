import 'dart:convert';
import 'package:crypto/crypto.dart';

// Fonction utilitaire pour le hachage
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

class AuthService {
  final Map<String, Map<String, dynamic>> _users = {
    'user@example.com': {
      'password': hashPassword('userpass'),
      'firstName': 'Jane',
      'lastName': 'Doe',
      'role': 'User',
    },
    'admin@example.com': {
      'password': hashPassword('adminpass'),
      'firstName': 'Admin',
      'lastName': 'User',
      'role': 'Admin',
    },
  };

  // Méthode de connexion
  Future<Map<String, dynamic>?> login(String email, String password) async {
    if (_users.containsKey(email)) {
      String hashedPassword = hashPassword(password);
      if (_users[email]!['password'] == hashPassword(password)) {
        return _users[email];
      }
    }
    return null;
  }
}
