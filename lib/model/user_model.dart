class UserModel {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      createdAt:
          map['\$createdAt'] != null
              ? DateTime.parse(map['\$createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? bio,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
