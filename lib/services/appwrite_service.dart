// lib/services/appwrite_service.dart
import 'package:appwrite/appwrite.dart'; // Importación correcta
import 'package:appturismo/core/config/app_config.dart';

class AppwriteService {
  late final Client client;
  late final Account account;
  late final Databases db;
  late final Avatars avatars;
  // late final Storage storage; // Descomenta si lo necesitas

  AppwriteService() {
    client = AppwriteConfig.initClient();
    account = Account(client);
    db = Databases(client);
    avatars = Avatars(client);
    // storage = Storage(client); // Descomenta si lo usas
  }
}
