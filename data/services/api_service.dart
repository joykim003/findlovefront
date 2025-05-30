import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/user_profile.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Récupérer la liste des profils disponibles
  Future<List<UserProfile>> getProfiles() async {
    try {
      print('Tentative de connexion à: $baseUrl/profiles');
      final response = await http.get(Uri.parse('$baseUrl/profiles'));
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserProfile.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des profils: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur détaillée: $e');
      throw Exception('Erreur lors de la récupération des profils: $e');
    }
  }

  // Like un profil
  Future<Map<String, dynamic>> likeProfile(int profileId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/like'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Échec du like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du like: $e');
    }
  }

  // Passer un profil
  Future<Map<String, dynamic>> passProfile(int profileId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/pass'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Échec du pass: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du pass: $e');
    }
  }

  // Super like un profil (à implémenter côté backend)
  Future<Map<String, dynamic>> superLikeProfile(int profileId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profiles/$profileId/super-like'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Échec du super like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du super like: $e');
    }
  }

  Future<Map<String, dynamic>> uploadPhoto(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-photo'),
      );

      // Importez 'package:mime/mime.dart' en haut du fichier si ce n'est pas déjà fait.
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Échec de l\'upload: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'upload: $e');
    }
  }
} 