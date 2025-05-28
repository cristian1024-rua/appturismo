import 'package:appwrite/appwrite.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';

class FavoritesRepository {
  final Databases _db;
  FavoritesRepository(this._db);

  Future<List<String>> getFavoritePlaceIds(String userId) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionFavorites,
      queries: [Query.equal('userId', userId)],
    );
    return res.documents.map((d) => d.data['placeId'] as String).toList();
  }

  Future<void> addFavorite(String u, String pid) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionFavorites,
      documentId: ID.unique(),
      data: {'userId': u, 'placeId': pid},
      permissions: [
        Permission.read(Role.user(u)),
        Permission.write(Role.user(u)),
      ],
    );
  }

  Future<void> removeFavorite(String u, String pid) async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionFavorites,
      queries: [Query.equal('userId', u), Query.equal('placeId', pid)],
    );
    if (res.documents.isNotEmpty) {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionFavorites,
        documentId: res.documents.first.$id,
      );
    }
  }
}
