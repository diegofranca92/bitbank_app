import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth_Service extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  Auth_Service() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }
}
