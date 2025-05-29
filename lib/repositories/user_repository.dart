import 'package:appturismo/model/user_model.dart';
import 'package:appwrite/appwrite.dart';

import '../core/constants/appwrite_constants.dart';
import 'dart:typed_data';

class UserRepository {
  final Databases _databases;
  final Storage _storage;

  UserRepository(this._databases, this._storage);

  // Obtener perfil de usuario
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final document = await _databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userId,
      );
      return UserModel.fromMap(document.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      rethrow;
    }
  }

  // Crear perfil de usuario
  Future<UserModel> createUserProfile(UserModel user) async {
    try {
      final document = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.id,
        data: user.toMap(),
      );
      return UserModel.fromMap(document.data);
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  // Actualizar perfil de usuario
  Future<UserModel> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final document = await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userId,
        data: data,
      );
      return UserModel.fromMap(document.data);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Subir imagen de perfil
  Future<String> uploadProfileImage(
    String userId,
    Uint8List fileBytes,
    String fileName,
  ) async {
    try {
      final file = await _storage.createFile(
        bucketId: AppwriteConstants.profileImagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
      );

      return _storage
          .getFileView(
            bucketId: AppwriteConstants.profileImagesBucket,
            fileId: file.$id,
          )
          .toString();
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }
}
