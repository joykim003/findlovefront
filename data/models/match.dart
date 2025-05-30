import 'user_profile.dart';

class Match {
  final int id;
  final UserProfile profile;
  final bool isMutual;
  final DateTime createdAt;

  Match({
    required this.id,
    required this.profile,
    required this.isMutual,
    required this.createdAt,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int,
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      isMutual: json['is_mutual'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile.toJson(),
      'is_mutual': isMutual,
      'created_at': createdAt.toIso8601String(),
    };
  }
} 