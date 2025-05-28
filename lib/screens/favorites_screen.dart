import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/place_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favCtrl = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: Obx(() {
        if (favCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final favs = favCtrl.favorites;
        if (favs.isEmpty) {
          return const Center(child: Text('No tienes favoritos aún.'));
        }
        return ListView.builder(
          itemCount: favs.length,
          itemBuilder: (_, i) {
            final doc = favs[i];
            return PlaceCard(
              doc: doc,
              onTap: () => Get.toNamed('/detail', arguments: doc),
            );
          },
        );
      }),
    );
  }
}
