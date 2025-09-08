class AuthUser {
  final dynamic id;
  final String email;
  final String name;
  final int age;
  final String gender;
  final String orientation;
  final String bio;
  final String? location;
  final List<String> interests;
  final List<String> photos;
  final bool isAuthenticated;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    required this.orientation,
    required this.bio,
    this.location,
    required this.interests,
    required this.photos,
    this.isAuthenticated = true,
  });

  factory AuthUser.anonymous() {
    return const AuthUser(
      id: -1,
      email: '',
      name: '',
      age: 0,
      gender: '',
      orientation: '',
      bio: '',
      interests: [],
      photos: [],
      isAuthenticated: false,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      orientation: json['orientation'] as String,
      bio: json['bio'] as String,
      location: json['location'] as String?,
      interests: List<String>.from(json['interests'] as List),
      photos: List<String>.from(json['photos'] as List),
      isAuthenticated: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'orientation': orientation,
      'bio': bio,
      'location': location,
      'interests': interests,
      'photos': photos,
      'isAuthenticated': isAuthenticated,
    };
  }

  AuthUser copyWith({
    dynamic id,
    String? email,
    String? name,
    int? age,
    String? gender,
    String? orientation,
    String? bio,
    String? location,
    List<String>? interests,
    List<String>? photos,
    bool? isAuthenticated,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      orientation: orientation ?? this.orientation,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      photos: photos ?? this.photos,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
} 