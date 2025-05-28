import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/place_card.dart';

class FavoritesListWidget extends StatelessWidget {
  const FavoritesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FavoritesController>();

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.favorites.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tienes favoritos aún',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: ctrl.favorites.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (_, i) {
          final place = ctrl.favorites[i];

          return PlaceCard(
            place: place,
            onTap: () => Get.toNamed('/detail', arguments: place),
            showFavoriteButton: true,
            isFavorite: true,
            onFavoriteToggle: () => ctrl.removeFavorite(place.id),
          );
        },
      );
    });
  }
}
