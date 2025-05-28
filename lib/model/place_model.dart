// lib/model/place_model.dart
import 'package:appwrite/models.dart';

class Place {
  final String id;
  final String title; // **Usamos 'title' como nombre del lugar/título**
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String createdBy;
  final String?
  userName; // Para mostrar el nombre del usuario que creó el lugar

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    this.userName,
    required String name,
  });

  factory Place.fromDocument(Document doc) {
    return Place(
      id: doc.$id,
      title:
          doc.data['title']
              as String, // Campo 'title' de tu colección de Appwrite
      description: doc.data['description'] as String,
      imageUrl: doc.data['imageUrl'] as String,
      latitude: (doc.data['latitude'] as num).toDouble(),
      longitude: (doc.data['longitude'] as num).toDouble(),
      createdBy: doc.data['createdBy'] as String,
      userName: doc.data['userName'] as String?,
      name: '', // Campo 'userName' si existe en tu colección
    );
  }

  get name => null;

  get data => null;

  get doc => null;

  Map<String, dynamic> toMap() {
    return {
      'title': title, // Guardar como 'title' en Appwrite
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
    };
  }
}
