class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({required this.id, required this.username, required this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'email': email};
  }
}
