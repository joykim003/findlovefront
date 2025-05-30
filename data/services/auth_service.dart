import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/data/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
  final _prefs = SharedPreferences.getInstance();
  static const _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  Future<void> _setToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> _clearToken() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    _dio.options.headers.remove('Authorization');
  }

  Future<AuthUser> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token non trouvé');

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/auth/me');
      return AuthUser.fromJson(response.data);
    } catch (e) {
      await _clearToken();
      rethrow;
    }
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      await _setToken(token);

      return AuthUser.fromJson(response.data['user']);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw 'Email ou mot de passe incorrect';
        }
        if (e.response?.data is Map) {
          throw e.response?.data['message'] ?? 'Une erreur est survenue';
        }
      }
      rethrow;
    }
  }

  Future<String> uploadPhoto(File photo, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/auth/upload-photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.data['url'];
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data is Map) {
          throw e.response?.data['message'] ?? 'Erreur lors de l\'upload de la photo';
        }
      }
      rethrow;
    }
  }

  Future<AuthUser> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required String orientation,
    required String bio,
    String? location,
    required List<String> interests,
    required List<String> photos,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
        'age': age,
        'gender': gender,
        'orientation': orientation,
        'bio': bio,
        'location': location,
        'interests': interests,
        'photos': photos,
      });

      final token = response.data['token'];
      await _setToken(token);

      return AuthUser.fromJson(response.data['user']);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 409) {
          throw 'Cet email est déjà utilisé';
        }
        if (e.response?.data is Map) {
          throw e.response?.data['message'] ?? 'Une erreur est survenue';
        }
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await _clearToken();
    }
  }
} 