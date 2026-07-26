import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/services/notification_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

final DatabaseReference _db = FirebaseDatabase.instance.ref('usuarios');


class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    // Escuchar cambios de autenticación
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      state = userCredential.user;
      await NotificationService.updateToken();
    } catch (e) {
      rethrow; // Lanza el error para manejarlo en la UI
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      state = userCredential.user;
      // Guardar en Realtime Database usando el UID como clave
      await _db.child(userCredential.user!.uid).set({
        'email': email,
        'uid': userCredential.user!.uid,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    state = null;
  }
}