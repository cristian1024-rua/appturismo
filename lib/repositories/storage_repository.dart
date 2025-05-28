import 'dart:io' as io;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;

class StorageRepository {
  final Storage _storage;
  final String bucketId;

  StorageRepository(this._storage, {required this.bucketId});

  Future<appwrite_models.File> uploadImage(io.File imageFile) async {
    try {
      final file = await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imageFile.path),
        permissions: [Permission.read(Role.any())],
      );
      return file;
    } on AppwriteException catch (e) {
      print('StorageRepository: Error uploading image: ${e.message}');
      throw Exception('Error al subir la imagen: ${e.message}');
    }
  }
}
