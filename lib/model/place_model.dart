import 'package:appwrite/models.dart';

class Place {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String createdBy;
  final String name;
  final String category;

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.name,
    required this.category,
  });

  factory Place.fromDocument(Document doc) {
    return Place(
      id: doc.$id,
      title: doc.data['title'] ?? '',
      description: doc.data['description'] ?? '',
      imageUrl: doc.data['imageUrl'] ?? '',
      latitude: (doc.data['latitude'] ?? 0).toDouble(),
      longitude: (doc.data['longitude'] ?? 0).toDouble(),
      createdBy: doc.data['createdBy'] ?? '',
      name: doc.data['name'] ?? '',
      category: doc.data['category'] ?? 'other',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'name': name,
      'category': category,
    };
  }
}
