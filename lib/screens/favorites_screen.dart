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
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (favCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favs = favCtrl.favorites;

        if (favs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No tienes favoritos aún',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/places'),
                  child: const Text('Explorar lugares'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => favCtrl.refreshFavorites(),
          child: ListView.builder(
            itemCount: favs.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, i) {
              final place = favs[i];

              return Dismissible(
                key: Key(place.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => favCtrl.removeFavorite(place.id),
                child: PlaceCard(
                  place: place,
                  onTap: () => Get.toNamed('/detail', arguments: place),
                  showFavoriteButton: true,
                  isFavorite: true,
                  onFavoriteToggle: () => favCtrl.removeFavorite(place.id),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
