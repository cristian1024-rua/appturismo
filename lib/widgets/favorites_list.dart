import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/place_card.dart';
import 'package:appturismo/model/place_model.dart';

class FavoritesListWidget extends StatelessWidget {
  FavoritesListWidget({super.key})
    : controller = Get.find<FavoritesController>();

  final FavoritesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Place> favs = controller.favorites;

      if (favs.isEmpty) {
        return const Center(child: Text('No favorite places yet.'));
      }

      return ListView.builder(
        itemCount: favs.length,
        itemBuilder: (ctx, i) {
          final place = favs[i];
          return PlaceCard(
            place: place,
            onTap: () {
              // Acción al tocar la tarjeta (opcional)
            },
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => controller.toggleFavorite(place),
            ),
          );
        },
      );
    });
  }
}
