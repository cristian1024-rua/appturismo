import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapCtrl = Get.find<MapController>();
    final placeCtrl = Get.find<PlaceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Lugares'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => mapCtrl.refreshLocation(),
          ),
        ],
      ),
      body: Obx(() {
        if (mapCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mapCtrl.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mapCtrl.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: mapCtrl.refreshLocation,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final position = mapCtrl.currentPosition.value;
        if (position == null) {
          return const Center(child: Text('No se pudo obtener tu ubicación'));
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: mapCtrl.zoomLevel.value,
              ),
              onMapCreated: mapCtrl.onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: mapCtrl.markers,
              onCameraMove: mapCtrl.onCameraMove,
              mapType: MapType.normal,
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar lugares...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    final pos = mapCtrl.currentPosition.value;
                    placeCtrl.fetchPlaces(
                      userLat: pos?.latitude,
                      userLon: pos?.longitude,
                      searchQuery: value,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
