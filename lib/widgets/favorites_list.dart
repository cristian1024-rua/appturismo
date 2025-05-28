import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/place_card.dart';

class FavoritesListWidget extends StatelessWidget {
  final FavoritesController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.favorites.isEmpty) {
        return const Center(child: Text('No tienes favoritos aún'));
      }
      return ListView.builder(
        itemCount: ctrl.favorites.length,
        itemBuilder: (_, i) {
          final doc = ctrl.favorites[i];
          return PlaceCard(
            doc: doc,
            onTap: () => Get.toNamed('/detail', arguments: doc),
          );
        },
      );
    });
  }
}
