// lib/repositories/user_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/core/config/app_config.dart';

class UserRepository {
  final Databases _databases;

  UserRepository({required Databases repository}) : _databases = repository;

  String get _databaseId => AppwriteConfig.appwriteDatabaseId;
  String get _usersCollectionId =>
      AppwriteConfig
          .usersCollectionId; // Asume que tienes una colección para perfiles de usuario

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final Document document = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
      );
      return document.data;
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return null;
      }
      print('UserRepository: Error getting user profile: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error getting user profile: $e');
      rethrow;
    }
  }

  Future<Document> createUserProfile(
    String userId,
    String name,
    String email,
  ) async {
    try {
      return await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: {'name': name, 'email': email, 'userId': userId},
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.write(Role.user(userId)),
        ],
      );
    } on AppwriteException catch (e) {
      print('UserRepository: Error creating user profile: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error creating user profile: $e');
      rethrow;
    }
  }

  // **** MÉTODOS AÑADIDOS PARA SOPORTAR USERCONTROLLER Y HOMESCREEN ****
  Future<List<Document>> getAllUsers() async {
    try {
      final DocumentList result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        queries: [
          Query.limit(100), // Limita el número de usuarios si hay muchos
        ],
      );
      return result.documents;
    } on AppwriteException catch (e) {
      print('UserRepository: Error getting all users: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error getting all users: $e');
      rethrow;
    }
  }

  Future<Document> addUser(Map<String, dynamic> userData) async {
    try {
      // Asume que el `userData` incluye 'userId', 'name', 'email'
      final String newUserId =
          userData['userId'] ??
          ID.unique(); // Usar userId si viene, o generar uno nuevo
      return await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: newUserId,
        data: userData,
        permissions: [
          Permission.read(
            Role.any(),
          ), // O solo Role.user() si es un perfil público
          Permission.write(Role.user(newUserId)),
        ],
      );
    } on AppwriteException catch (e) {
      print('UserRepository: Error adding user: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error adding user: $e');
      rethrow;
    }
  }

  Future<Document> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      return await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: userData,
      );
    } on AppwriteException catch (e) {
      print('UserRepository: Error updating user: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
      );
    } on AppwriteException catch (e) {
      print('UserRepository: Error deleting user: ${e.message}');
      rethrow;
    } catch (e) {
      print('UserRepository: Unknown error deleting user: $e');
      rethrow;
    }
  }

  // **** FIN MÉTODOS AÑADIDOS ****
}
