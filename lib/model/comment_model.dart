// lib/model/comment_model.dart
import 'package:appwrite/models.dart';

class CommentModel {
  final String id;
  final String userId;
  final String placeId;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.text,
    required this.createdAt,
    required username,
    required String content,
  });

  factory CommentModel.fromDocument(Document doc) {
    return CommentModel(
      id: doc.$id,
      userId: doc.data['userId'] as String,
      placeId: doc.data['placeId'] as String,
      text: doc.data['text'] as String,
      createdAt: DateTime.parse(doc.$createdAt),
      username: null,
      content: '',
    );
  }

  String? get content => null;

  get username => null;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
