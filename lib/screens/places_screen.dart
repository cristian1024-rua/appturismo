import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/place_card.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performInitialSearch();
    });
  }

  void _performInitialSearch() {
    final placeCtrl = Get.find<PlaceController>();
    final locCtrl = Get.find<LocationController>();
    _performSearch('', placeCtrl, locCtrl);
  }

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceController>();
    final locCtrl = Get.find<LocationController>();
    final favCtrl = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Get.toNamed('/map'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar lugares turísticos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchCtrl.clear();
                    _performSearch('', placeCtrl, locCtrl);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => _performSearch(value, placeCtrl, locCtrl),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (placeCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (placeCtrl.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(placeCtrl.error.value),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => _performSearch(
                              searchCtrl.text,
                              placeCtrl,
                              locCtrl,
                            ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (placeCtrl.places.isEmpty) {
                return const Center(
                  child: Text('No se encontraron lugares turísticos'),
                );
              }

              return RefreshIndicator(
                onRefresh:
                    () async =>
                        _performSearch(searchCtrl.text, placeCtrl, locCtrl),
                child: ListView.builder(
                  itemCount: placeCtrl.places.length,
                  itemBuilder: (context, index) {
                    final place = placeCtrl.places[index];
                    return PlaceCard(
                      place: place,
                      onTap: () => Get.toNamed('/detail', arguments: place),
                      showFavoriteButton: true,
                      isFavorite: favCtrl.isFavorite(place.id),
                      onFavoriteToggle: () {
                        if (favCtrl.isFavorite(place.id)) {
                          favCtrl.removeFavorite(place.id);
                        } else {
                          favCtrl.addFavorite(place);
                        }
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _performSearch(
    String query,
    PlaceController placeCtrl,
    LocationController locCtrl,
  ) {
    final pos = locCtrl.currentLocation.value;
    placeCtrl.fetchPlaces(
      userLat: pos?.latitude,
      userLon: pos?.longitude,
      searchQuery: query,
    );
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
