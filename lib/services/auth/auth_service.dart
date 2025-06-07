// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream del estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registrar usuario
  Future<User?> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
    return cred.user;
  }

  // Iniciar sesión
  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email, password: password);
    return cred.user;
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }
}