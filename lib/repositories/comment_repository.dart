import 'package:appturismo/model/comment_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';

class CommentRepository {
  final Databases _db;

  CommentRepository(this._db);

  Future<List<Document>> getComments(String placeId) async {
    try {
      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionComments,
        queries: [
          Query.equal('placeId', placeId),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return result.documents;
    } catch (e) {
      print('Error getting comments: $e');
      rethrow;
    }
  }

  Future<Document> addComment(CommentModel comment) async {
    try {
      return await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionComments,
        documentId: ID.unique(),
        data: {
          'userId': comment.userId,
          'placeId': comment.placeId,
          'text': comment.text,
          'username': comment.username,
        },
      );
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  Future<List<CommentModel>> getCommentsForPlace(String placeId) async {
    try {
      final documents = await getComments(placeId);
      return documents.map((doc) => CommentModel.fromDocument(doc)).toList();
    } catch (e) {
      print('Error getting comments for place: $e');
      rethrow;
    }
  }
}
