import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado, Cadastre-se');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorrecta, tente novamente');
      }
    }
  }

  signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        throw AuthException('A senha é muito fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está em uso');
      }
    }
  }

  signOut() async {
    await _auth.signOut();
    _getUser();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    _auth.currentUser;
    notifyListeners();
  }
}
