import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/data/services/api_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;
  final String? email;
  final int? id;

  AuthState({
    required this.isAuthenticated,
    this.token,
    this.error,
    this.email,
    this.id,
  });

  factory AuthState.initial() => AuthState(isAuthenticated: false);
  factory AuthState.authenticated(String token, {String? email, int? id}) =>
      AuthState(isAuthenticated: true, token: token, email: email, id: id);
  factory AuthState.error(String error) =>
      AuthState(isAuthenticated: false, error: error);
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final ApiService _apiService;
  final AuthService _authService;
  final _uuid = const Uuid();
  static const String _tokenKey = 'auth_token';

  AuthNotifier(this._apiService, this._authService)
      : super(const AsyncValue.loading()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      print('Token chargé: ${token != null ? "présent" : "absent"}');

      if (token != null) {
        state = AsyncValue.data(AuthState.authenticated(token));
      } else {
        state = AsyncValue.data(AuthState.initial());
      }
    } catch (e, stack) {
      print('Erreur lors du chargement du token: $e');
      print('Stack trace: $stack');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print('Tentative de connexion...');
      state = const AsyncValue.loading();

      final response = await _apiService.post('/auth/login', body: {
        'email': email,
        'password': password,
      });

      print('Réponse de connexion: $response');

      if (response['token'] != null) {
        final token = response['token'];
        final user = response['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        print('Token sauvegardé avec succès');
        state = AsyncValue.data(AuthState.authenticated(
          token,
          email: email,
          id: user['id'],
        ));
      } else {
        throw 'Token non reçu dans la réponse';
      }
    } catch (e, stack) {
      print('Erreur lors de la connexion: $e');
      print('Stack trace: $stack');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      print('Déconnexion...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      print('Token supprimé');
      state = AsyncValue.data(AuthState.initial());
    } catch (e, stack) {
      print('Erreur lors de la déconnexion: $e');
      print('Stack trace: $stack');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required String orientation,
    required String bio,
    String? location,
    required List<String> interests,
    required List<File> photos,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Upload des photos
      final photoUrls = await Future.wait(
        photos.map((photo) async {
          final extension = photo.path.split('.').last;
          final fileName = '${_uuid.v4()}.$extension';
          return await _authService.uploadPhoto(photo, fileName);
        }),
      );

      final response = await _apiService.post('/auth/register', body: {
        'email': email,
        'password': password,
        'name': name,
        'age': age,
        'gender': gender,
        'orientation': orientation,
        'bio': bio,
        'location': location,
        'interests': interests,
        'photos': photoUrls,
      });

      if (response['token'] != null) {
        final token = response['token'];
        final user = response['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        state = AsyncValue.data(AuthState.authenticated(
          token,
          email: email,
          id: user['id'],
        ));
      } else {
        throw 'Token non reçu dans la réponse';
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(ApiService(), AuthService());
});
