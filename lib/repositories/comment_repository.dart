import 'package:appwrite/appwrite.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appturismo/model/comment_model.dart';

class CommentRepository {
  final Databases _db;
  CommentRepository(this._db);

  Future<List<CommentModel>> getCommentsForPlace(String pid) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionComments,
      queries: [Query.equal('placeId', pid)],
    );
    return res.documents.map(CommentModel.fromDocument).toList();
  }

  Future<void> addComment(CommentModel c) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionComments,
      documentId: ID.unique(),
      data: c.toJson(),
      permissions: [
        Permission.read(Role.any()),
        Permission.write(Role.user(c.userId)),
      ],
    );
  }
}
