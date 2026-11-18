
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

  // Registrasi pengguna dengan nama dan role
  Future<AuthResponse> register({
    required String email,
    required String password,
    String name = '',
    String role = 'seeker',
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
        'role': role,
      },
    );
  }

  // Login pengguna
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout pengguna
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
