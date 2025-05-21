// lib/repositories/place_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/config/app_config.dart';
import 'package:appturismo/model/place_model.dart'; // Importa tu Place

class PlaceRepository {
  final Databases _databases;

  PlaceRepository(this._databases);

  String get _databaseId => AppwriteConfig.appwriteDatabaseId;
  String get _placesCollectionId => AppwriteConfig.placesCollectionId;

  Future<List<Place>> getPlaces({String? query}) async {
    try {
      List<String> queries = [];
      if (query != null && query.isNotEmpty) {
        queries.add(
          Query.search('title', query),
        ); // **Busca por 'title' en la colección**
      }

      // Opcional: ordenar los resultados
      queries.add(Query.orderDesc('\$createdAt'));

      final DocumentList result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _placesCollectionId,
        queries: queries,
      );
      return result.documents.map((doc) => Place.fromDocument(doc)).toList();
    } on AppwriteException catch (e) {
      print('PlaceRepository: Error al obtener lugares: ${e.message}');
      rethrow;
    } catch (e) {
      print('PlaceRepository: Unknown error al obtener lugares: $e');
      rethrow;
    }
  }

  Future<Place> getPlaceById(String placeId) async {
    try {
      final Document document = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _placesCollectionId,
        documentId: placeId,
      );
      return Place.fromDocument(document);
    } on AppwriteException catch (e) {
      print('PlaceRepository: Error al obtener lugar por ID: ${e.message}');
      rethrow;
    } catch (e) {
      print('PlaceRepository: Unknown error al obtener lugar por ID: $e');
      rethrow;
    }
  }

  Future<Place> addPlace({required Place place}) async {
    try {
      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _placesCollectionId,
        documentId: ID.unique(),
        data: place.toMap(),
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.user(place.createdBy)),
        ],
      );
      return Place.fromDocument(response);
    } on AppwriteException catch (e) {
      print('PlaceRepository: Error al añadir lugar: ${e.message}');
      rethrow;
    } catch (e) {
      print('PlaceRepository: Unknown error al añadir lugar: $e');
      rethrow;
    }
  }
}
