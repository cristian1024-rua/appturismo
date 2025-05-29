import 'package:appwrite/models.dart';

class CommentModel {
  final String id;
  final String userId;
  final String placeId;
  final String text;
  final String username;

  CommentModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.text,
    required this.username,
  });

  factory CommentModel.fromDocument(Document doc) {
    return CommentModel(
      id: doc.$id,
      userId: doc.data['userId'] ?? '',
      placeId: doc.data['placeId'] ?? '',
      text: doc.data['text'] ?? '',
      username: doc.data['username'] ?? 'Anónimo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
      'text': text,
      'username': username,
      'createdAt':
          DateTime.now().toIso8601String(), // Agregamos el campo createdAt
    };
  }
}
