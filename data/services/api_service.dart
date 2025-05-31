import 'dart:convert';
import 'dart:io';
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Récupérer la liste des profils disponibles
  Future<List<UserProfile>> getProfiles() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profiles'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserProfile.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du chargement des profils: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors de la récupération des profils: $e';
    }
  }

  // Récupérer les matches
  Future<List<Match>> getMatches() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/matches'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Match.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec du chargement des matches: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors de la récupération des matches: $e';
    }
  }

  // Mettre à jour le profil
  Future<UserProfile> updateProfile({
    String? name,
    int? age,
    String? gender,
    String? orientation,
    List<String>? interests,
    String? bio,
    String? location,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
        body: json.encode({
          if (name != null) 'name': name,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
          if (orientation != null) 'orientation': orientation,
          if (interests != null) 'interests': interests,
          if (bio != null) 'bio': bio,
          if (location != null) 'location': location,
        }),
      );
      
      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw 'Session expirée, veuillez vous reconnecter';
      } else {
        throw 'Échec de la mise à jour du profil: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Erreur lors de la mise à jour du profil: $e';
    }
  }

  // Uploader une photo
  Future<String> uploadPhoto(File imageFile) async {
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

      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse['message'];
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
} 