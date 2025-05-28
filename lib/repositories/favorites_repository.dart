import 'package:appturismo/model/place_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';

class FavoritesRepository {
  final Databases _db;

  FavoritesRepository(this._db);

  Future<List<Document>> getFavorites(String userId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionFavorites,
        queries: [Query.equal('userId', userId)],
      );
      return response.documents;
    } catch (e) {
      print('Error in getFavorites: $e');
      throw 'Error al obtener favoritos';
    }
  }

  Future<void> addFavorite(String userId, Place place) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionFavorites,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'placeId': place.id,
          'title': place.title,
          'description': place.description,
          'imageUrl': place.imageUrl,
          'latitude': place.latitude,
          'longitude': place.longitude,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Error in addFavorite: $e');
      throw 'Error al agregar favorito';
    }
  }

  Future<void> removeFavorite(String userId, String placeId) async {
    try {
      final favorites = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionFavorites,
        queries: [
          Query.equal('userId', userId),
          Query.equal('placeId', placeId),
        ],
      );

      if (favorites.documents.isNotEmpty) {
        await _db.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.collectionFavorites,
          documentId: favorites.documents.first.$id,
        );
      }
    } catch (e) {
      print('Error in removeFavorite: $e');
      throw 'Error al eliminar favorito';
    }
  }
}
