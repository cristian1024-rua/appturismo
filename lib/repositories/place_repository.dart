import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceRepository {
  final Databases _db;

  PlaceRepository(this._db);

  Future<List<Document>> getPlaces({
    double? userLat,
    double? userLon,
    String? searchQuery,
    List<String>? categories, // Agregar este parámetro
  }) async {
    try {
      List<String> queries = [];

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queries.add(Query.search('title', searchQuery));
      }

      if (categories != null && categories.isNotEmpty) {
        queries.add(Query.equal('category', categories));
      }

      queries.add(Query.orderDesc('\$createdAt'));

      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        queries: queries,
      );

      return result.documents;
    } catch (e) {
      print('Error en PlaceRepository.getPlaces: $e');
      rethrow;
    }
  }

  Future<Document> addPlace(Place place) async {
    try {
      return await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        documentId: ID.unique(),
        data: place.toMap(),
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.user(place.createdBy)),
        ],
      );
    } catch (e) {
      print('Error creating place document: $e');
      rethrow;
    }
  }
}
