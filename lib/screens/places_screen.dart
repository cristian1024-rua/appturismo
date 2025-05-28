import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/widgets/place_card.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceController>();
    final locCtrl = Get.find<LocationController>();
    final auth = Get.find<AuthController>();
    final searchCtrl = TextEditingController();

    // Llamar a fetchPlaces una sola vez cuando se renderiza el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pos = locCtrl.currentLocation.value;
      placeCtrl.fetchPlaces(
        userLat: pos?.latitude,
        userLon: pos?.longitude,
        searchQuery: searchCtrl.text,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Get.toNamed('/map'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Buscar…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (q) {
                final pos = locCtrl.currentLocation.value;
                placeCtrl.fetchPlaces(
                  userLat: pos?.latitude,
                  userLon: pos?.longitude,
                  searchQuery: q,
                );
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (placeCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (placeCtrl.error.value.isNotEmpty) {
                return Center(child: Text(placeCtrl.error.value));
              }
              final docs = placeCtrl.places;
              if (docs.isEmpty) {
                return const Center(child: Text('No se encontraron lugares.'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder:
                    (_, i) => PlaceCard(
                      doc: docs[i],
                      onTap: () => Get.toNamed('/detail', arguments: docs[i]),
                    ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
