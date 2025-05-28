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
  final DateTime? createdAt;

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.name,
    this.category = 'other',
    this.createdAt,
  });

  factory Place.fromDocument(Document doc) {
    return Place(
      id: doc.$id,
      title: doc.data['title'] as String,
      description: doc.data['description'] as String,
      imageUrl: doc.data['imageUrl'] as String,
      latitude: (doc.data['latitude'] as num).toDouble(),
      longitude: (doc.data['longitude'] as num).toDouble(),
      createdBy: doc.data['createdBy'] as String,
      name: doc.data['title'] as String,
      category: doc.data['category'] as String? ?? 'other',
      createdAt: DateTime.tryParse(doc.$createdAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'category': category,
    };
  }
}
