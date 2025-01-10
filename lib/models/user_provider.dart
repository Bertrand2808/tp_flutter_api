import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _role;

  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get role => _role;

  void setUser(Map<String, dynamic> userData) {
    _email = userData['email'];
    _firstName = userData['first_name'];
    _lastName = userData['last_name'];
    _role = userData['role'];
    notifyListeners();
  }
}
