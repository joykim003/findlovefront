import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/match.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  static const String _tokenKey = 'auth_token';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, String>> _getHeaders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      print(
          'Token d\'authentification: ${token != null ? "présent" : "absent"}');
      return {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    } catch (e) {
      print('Erreur lors de la récupération des headers: $e');
      rethrow;
    }
  }

  // Récupérer la liste des profils disponibles
  Future<List<UserProfile>> getProfiles() async {
    try {
      print('Tentative de récupération des profils...');
      final headers = await _getHeaders();
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl/profiles'),
        headers: headers,
      );

      print('Réponse du serveur (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserProfile.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Erreur 401: Session expirée');
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        print('Erreur ${response.statusCode}: ${response.body}');
        throw 'Échec du chargement des profils: ${response.statusCode} - ${response.body}';
      }
    } catch (e, stack) {
      print('Erreur lors de la récupération des profils: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  // Récupérer les matches
  Future<List<Match>> getMatches() async {
    try {
      print('Tentative de récupération des matches...');
      final headers = await _getHeaders();
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl/matches'),
        headers: headers,
      );

      print('Réponse du serveur (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Match.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Erreur 401: Session expirée');
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        print('Erreur ${response.statusCode}: ${response.body}');
        throw 'Échec du chargement des matches: ${response.statusCode} - ${response.body}';
      }
    } catch (e, stack) {
      print('Erreur lors de la récupération des matches: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  // Mettre à jour le profil
  Future<UserProfile> updateProfile({
    String? name,
    int? age,
    String? gender,
    String? orientation,
    String? bio,
    String? location,
    List<String>? interests,
  }) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (orientation != null) 'orientation': orientation,
        if (bio != null) 'bio': bio,
        if (location != null) 'location': location,
        if (interests != null) 'interests': interests,
      }),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw 'Session expirée. Veuillez vous reconnecter.';
    } else {
      final error = jsonDecode(response.body);
      throw error['detail'] ??
          'Une erreur est survenue lors de la mise à jour du profil';
    }
  }

  // Uploader une photo
  Future<String> uploadPhoto(dynamic imageFile) async {
    try {
      final headers = await _getHeaders();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/photo'),
      );

      // Ajouter les headers d'authentification
      request.headers.addAll({
        'Authorization': headers['Authorization']!,
      });

      if (kIsWeb) {
        // Pour le web, on utilise directement le XFile
        final bytes = await imageFile.readAsBytes();
        final mimeType = lookupMimeType(imageFile.name) ?? 'image/jpeg';
        final fileName = imageFile.name;

        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            bytes,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        // Pour mobile/desktop, on utilise le File
        final file = imageFile as File;
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        // Retourner l'URL de la photo depuis la réponse
        return jsonResponse['url'] ?? jsonResponse['message'];
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec de l\'upload: ${jsonResponse['message']}';
      }
    } catch (e) {
      throw 'Erreur lors de l\'upload: $e';
    }
  }

  // Supprimer une photo
  Future<void> deletePhoto(int photoIndex) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/profile/photo/$photoIndex'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        final jsonResponse = json.decode(response.body);
        throw 'Échec de la suppression: ${jsonResponse['message']}';
      }
    } catch (e) {
      throw 'Erreur lors de la suppression de la photo: $e';
    }
  }

  // Like un profil
  Future<Map<String, dynamic>> likeProfile(int profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/like'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du like: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors du like: $e';
    }
  }

  // Passer un profil
  Future<Map<String, dynamic>> passProfile(int profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/pass'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du pass: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors du pass: $e';
    }
  }

  // Super like un profil
  Future<Map<String, dynamic>> superLikeProfile(int profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/superlike'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du super like: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors du super like: $e';
    }
  }

  // Récupérer un profil spécifique
  Future<UserProfile> getProfile(int profileId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profiles/$profileId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du chargement du profil: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors de la récupération du profil: $e';
    }
  }

  // Méthode générique pour les requêtes POST
  Future<Map<String, dynamic>> post(String endpoint,
      {required Map<String, dynamic> body}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        final error = json.decode(response.body);
        throw error['detail'] ?? error['message'] ?? 'Une erreur est survenue';
      }
    } catch (e) {
      if (e is String) rethrow;
      throw 'Erreur lors de la requête: $e';
    }
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw 'Session expirée. Veuillez vous reconnecter.';
      } else {
        throw 'Erreur: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur de connexion: $e';
    }
  }

  // Mettre à jour le token FCM
  Future<void> updateFcmToken(String token) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/profile/fcm-token'),
        headers: headers,
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw 'Échec de la mise à jour du token FCM: ${response.statusCode}';
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du token FCM: $e');
    }
  }
}
