import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../services/gmail_api_service.dart';
import 'correo_viewmodel.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthViewmodel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final GmailApiService gmailApiService = GmailApiService();

  AuthStatus _status = AuthStatus.unauthenticated;
  String _errorMessage = '';
  GoogleSignInAccount? _user;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  GoogleSignInAccount? get user => _user;
  String get userEmail => _user?.email ?? '';
  String get userName => _user?.displayName ?? '';
  String? get userPhotoUrl => _user?.photoUrl;
  bool get isSignedIn => _status == AuthStatus.authenticated;

  Future<bool> signIn(CorreoViewmodel correoVm) async {
    _status = AuthStatus.authenticating;
    _errorMessage = '';
    notifyListeners();

    try {
      final account = await _authService.signIn();
      if (account == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      _user = account;
      final headers = await _authService.getAuthHeaders();
      await gmailApiService.initialize(headers);

      _status = AuthStatus.authenticated;
      notifyListeners();

      await correoVm.cargarCorreos(gmailApiService);
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Error al iniciar sesión: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshEmails(CorreoViewmodel correoVm) async {
    if (_status != AuthStatus.authenticated) return;
    try {
      final headers = await _authService.getAuthHeaders();
      await gmailApiService.initialize(headers);
      await correoVm.cargarCorreos(gmailApiService);
    } catch (e) {
      _errorMessage = 'Error al recargar: $e';
      notifyListeners();
    }
  }

  Future<void> signOut(CorreoViewmodel correoVm) async {
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    correoVm.limpiarCorreos();
    notifyListeners();
  }
}
