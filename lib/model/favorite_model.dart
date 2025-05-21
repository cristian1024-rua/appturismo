// lib/model/favorite_model.dart
import 'package:appwrite/models.dart' as appwrite_models;

class Favorite {
  final String? id; // El ID del documento de Appwrite (ej: "65b2d2f...")
  final String userId;
  final String placeId;
  final DateTime? createdAt; // Fecha de creación (Appwrite la proporciona)
  final DateTime?
  updatedAt; // Fecha de última actualización (Appwrite la proporciona)

  Favorite({
    this.id,
    required this.userId,
    required this.placeId,
    this.createdAt,
    this.updatedAt,
  });

  // Constructor de fábrica para crear una instancia de Favorite desde un Map (documento de Appwrite)
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['\$id'] as String?, // Appwrite usa '$id' para el ID del documento
      userId: map['userId'] as String,
      placeId: map['placeId'] as String,
      createdAt:
          map['\$createdAt'] != null
              ? DateTime.parse(map['\$createdAt'] as String)
              : null,
      updatedAt:
          map['\$updatedAt'] != null
              ? DateTime.parse(map['\$updatedAt'] as String)
              : null,
    );
  }

  // Constructor de fábrica para crear una instancia de Favorite desde un objeto Document de Appwrite
  factory Favorite.fromDocument(appwrite_models.Document document) {
    return Favorite.fromMap(document.data);
  }

  // Método para convertir la instancia de Favorite a un Map para enviar a Appwrite
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'placeId': placeId,
      // No incluyas '$id', '$createdAt', '$updatedAt' aquí, Appwrite los gestiona automáticamente al crear/actualizar
    };
  }
}
