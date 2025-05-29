import 'package:appturismo/model/comment_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceRepository {
  final Databases _db;

  PlaceRepository(this._db);

  Future<List<Place>> getPlaces({
    String? query,
    List<String>? categories,
    double? userLat,
    double? userLon,
    required double radius,
  }) async {
    try {
      List<String> queries = [];

      if (query != null && query.isNotEmpty) {
        queries.add(Query.search('title', query));
      }

      if (categories != null && categories.isNotEmpty) {
        queries.add(Query.equal('category', categories));
      }

      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        queries: queries,
      );

      return result.documents.map((doc) => Place.fromDocument(doc)).toList();
    } catch (e) {
      print('Error getting places: $e');
      rethrow;
    }
  }

  // Agregar el método que falta y que es requerido por PlaceController
  Future<Place> addPlace(Place place) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        documentId: ID.unique(),
        data: place.toJson(),
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.user(place.createdBy)),
          Permission.update(Role.user(place.createdBy)),
          Permission.delete(Role.user(place.createdBy)),
        ],
      );

      return Place.fromDocument(document);
    } catch (e) {
      print('Error adding place: $e');
      rethrow;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionComments,
        documentId: ID.unique(),
        data:
            comment.toJson(), // El campo createdAt ya está incluido en toJson()
      );
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  // Opcional: Agregar métodos para actualizar y eliminar lugares
  Future<void> updatePlace(Place place) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        documentId: place.id,
        data: place.toJson(),
      );
    } catch (e) {
      print('Error updating place: $e');
      rethrow;
    }
  }

  Future<void> deletePlace(String placeId) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        documentId: placeId,
      );
    } catch (e) {
      print('Error deleting place: $e');
      rethrow;
    }
  }
}
