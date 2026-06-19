import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/gmail.readonly',
      'https://www.googleapis.com/auth/gmail.send',
      'https://www.googleapis.com/auth/gmail.labels',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();
  Future<void> signOut() => _googleSignIn.signOut();

  bool get isSignedIn => _googleSignIn.currentUser != null;
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<Map<String, String>> getAuthHeaders() async {
    final account = _googleSignIn.currentUser;
    if (account == null) throw Exception('No authenticated user');
    final authHeaders = await account.authHeaders;

    final headers = Map<String, String>.from(authHeaders);

    if (!headers.containsKey('Authorization')) {
      final token = await account.authentication;
      headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return headers;
  }
}
