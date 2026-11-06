import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    await _client.auth.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: emailRedirectTo ?? Uri.base.toString(),
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
