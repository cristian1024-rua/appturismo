// lib/repositories/favorites_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/config/app_config.dart';

class FavoritesRepository {
  final Databases _databases;

  FavoritesRepository(this._databases);

  String get _databaseId => AppwriteConfig.appwriteDatabaseId;
  String get _favoritesCollectionId => AppwriteConfig.favoritesCollectionId;

  Future<List<String>> getFavoritePlaceIds(String userId) async {
    try {
      final DocumentList response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _favoritesCollectionId,
        queries: [Query.equal('userId', userId)],
      );
      return response.documents
          .map((doc) => doc.data['placeId'] as String)
          .toList();
    } on AppwriteException catch (e) {
      print(
        'FavoritesRepository: Error getting favorite place IDs: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print(
        'FavoritesRepository: Unknown error getting favorite place IDs: $e',
      );
      rethrow;
    }
  }

  Future<void> addFavorite(String userId, String placeId) async {
    try {
      final existing = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _favoritesCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('placeId', placeId),
        ],
      );
      if (existing.documents.isNotEmpty) {
        return; // Ya es un favorito, no hacer nada
      }

      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _favoritesCollectionId,
        documentId: ID.unique(),
        data: {'userId': userId, 'placeId': placeId},
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.write(Role.user(userId)),
        ],
      );
    } on AppwriteException catch (e) {
      print('FavoritesRepository: Error adding favorite: ${e.message}');
      rethrow;
    } catch (e) {
      print('FavoritesRepository: Unknown error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      final DocumentList docsToRemove = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _favoritesCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('placeId', placeId),
        ],
      );

      if (docsToRemove.documents.isNotEmpty) {
        await _databases.deleteDocument(
          databaseId: _databaseId,
          collectionId: _favoritesCollectionId,
          documentId: docsToRemove.documents.first.$id,
        );
      }
    } on AppwriteException catch (e) {
      print('FavoritesRepository: Error removing favorite: ${e.message}');
      rethrow;
    } catch (e) {
      print('FavoritesRepository: Unknown error removing favorite: $e');
      rethrow;
    }
  }
}
