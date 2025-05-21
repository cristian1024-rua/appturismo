// lib/repositories/comment_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/config/app_config.dart';
import 'package:appturismo/model/comment_model.dart';

class CommentRepository {
  final Databases _databases;

  CommentRepository(this._databases);

  String get _databaseId => AppwriteConfig.appwriteDatabaseId;
  String get _commentsCollectionId => AppwriteConfig.commentsCollectionId;

  Future<List<CommentModel>> getCommentsForPlace(String placeId) async {
    try {
      final DocumentList response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _commentsCollectionId,
        queries: [
          Query.equal('placeId', placeId),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return response.documents
          .map((doc) => CommentModel.fromDocument(doc))
          .toList();
    } on AppwriteException catch (e) {
      print('CommentRepository: Error getting comments: ${e.message}');
      rethrow;
    } catch (e) {
      print('CommentRepository: Unknown error getting comments: $e');
      rethrow;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _commentsCollectionId,
        documentId: ID.unique(),
        data: comment.toJson(),
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.user(comment.userId)),
        ],
      );
    } on AppwriteException catch (e) {
      print('CommentRepository: Error adding comment: ${e.message}');
      rethrow;
    } catch (e) {
      print('CommentRepository: Unknown error adding comment: $e');
      rethrow;
    }
  }
}
