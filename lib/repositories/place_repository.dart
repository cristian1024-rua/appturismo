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
  }) => _db
      .listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionPlaces,
        queries: [
          if (searchQuery != null && searchQuery.isNotEmpty)
            Query.search('title', searchQuery),
          Query.orderDesc('\$createdAt'),
        ],
      )
      .then((res) => res.documents);

  Future<Place> addPlace({required Place place}) async {
    final doc = await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.collectionPlaces,
      documentId: ID.unique(),
      data: place.toMap(),
      permissions: [
        Permission.read(Role.any()),
        Permission.write(Role.user(place.createdBy)),
      ],
    );
    return Place.fromDocument(doc);
  }
}
