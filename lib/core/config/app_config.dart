// lib/core/config/app_config.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static Client initClient() {
    return Client()
        .setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!)
        .setProject(dotenv.env['APPWRITE_PROJECT_ID']!)
        .setSelfSigned(
          status: true,
        ); // Solo para desarrollo, si tu Appwrite no tiene SSL válido
  }

  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID']!;
  static String get appwriteEndpoint => dotenv.env['APPWRITE_ENDPOINT']!;
  static String get appwriteProjectId => dotenv.env['APPWRITE_PROJECT_ID']!;
  static String get appwriteDatabaseId => dotenv.env['APPWRITE_DATABASE_ID']!;
  static String get placesCollectionId =>
      dotenv.env['APPWRITE_PLACES_COLLECTION_ID']!;
  static String get commentsCollectionId =>
      dotenv.env['APPWRITE_COMMENTS_COLLECTION_ID']!;
  static String get usersCollectionId =>
      dotenv.env['APPWRITE_USERS_COLLECTION_ID']!;
  static String get favoritesCollectionId =>
      dotenv.env['APPWRITE_FAVORITES_COLLECTION_ID']!;
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY']!;
}
