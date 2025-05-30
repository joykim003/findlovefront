// lib/data/models/user_profile.dart

// TODO: Si vous utilisez une librairie pour la sérialisation JSON (comme json_serializable),
// vous devrez ajouter les annotations et générer le code.
// import 'package:json_annotation/json_annotation.dart';
// part 'user_profile.g.dart';

// @JsonSerializable() // Ajoutez cette annotation si vous utilisez json_serializable
class UserProfile {
  final int id;
  final String name;
  final int age;
  final String gender; // Ajout du genre
  final String orientation; // Ajout de l'orientation
  final String? location; // La localisation pourrait être optionnelle
  final List<String> interests; // Liste d'intérêts (String pour l'instant)
  final String? bio; // La bio pourrait être optionnelle
  final List<String> photos; // Liste d'URLs ou de chemins d'accès aux photos (String pour l'instant)

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender, // Rendu obligatoire
    required this.orientation, // Rendu obligatoire
    this.location,
    required this.interests, // Rendu obligatoire
    this.bio,
    required this.photos, // Rendu obligatoire
  });

  // Factory method pour créer un UserProfile à partir d'un Map (souvent utilisé pour le JSON)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Fonction helper pour nettoyer les listes
    List<String> cleanList(dynamic list) {
      if (list is List) {
        return list.map((item) {
          if (item is String) {
            // Enlève les crochets et guillemets supplémentaires
            return item.replaceAll('[', '').replaceAll(']', '').replaceAll("'", '');
          }
          return item.toString();
        }).toList();
      }
      return [];
    }

    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      orientation: json['orientation'] as String,
      location: json['location'] as String?,
      interests: cleanList(json['interests']),
      bio: json['bio'] as String?,
      photos: cleanList(json['photos']),
    );
  }

  // Méthode optionnelle pour convertir UserProfile en Map (pour l'envoyer au backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'orientation': orientation,
      'location': location,
      'interests': interests,
      'bio': bio,
      'photos': photos,
    };
  }

  // Méthode optionnelle pour faciliter le débogage
  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, age: $age, gender: $gender, orientation: $orientation, location: $location, interests: $interests, bio: $bio, photos: ${photos.length} photos)';
  }
}

// TODO: Vous pourriez définir des Enums ou des classes spécifiques pour Gender et Orientation
// enum Gender { male, female, nonBinary }
// enum Orientation { straight, gay, lesbian, bisexual }
// TODO Implement this library.
