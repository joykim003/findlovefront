class UserProfile {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String orientation;
  final List<String> interests;
  final List<String> photos;
  final String bio;
  final String location;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.orientation,
    required this.interests,
    required this.photos,
    required this.bio,
    required this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      orientation: json['orientation'],
      interests: List<String>.from(json['interests']),
      photos: List<String>.from(json['photos']),
      bio: json['bio'],
      location: json['location'],
    );
  }
} 