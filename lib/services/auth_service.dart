import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final SupabaseClient _client = Supabase.instance.client;

  // Mendapatkan user yang sedang login
  User? get currentUser => _client.auth.currentUser;

  // Mendapatkan session pengguna
  Session? get currentSession => _client.auth.currentSession;

  // Memeriksa status login
  bool get isLoggedIn => currentSession != null;

  // Registrasi
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
