import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ← CORRECTO
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/widgets/place_marker.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapController mapCtrl = Get.find<MapController>();
  final PlaceController placeCtrl = Get.find<PlaceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Lugares')),
      body: Obx(() {
        if (mapCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pos = mapCtrl.currentPosition.value;
        if (pos == null) {
          return const Center(child: Text('Obteniendo ubicación actual...'));
        }

        // Espera a que los lugares estén cargados
        if (placeCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(pos.latitude, pos.longitude),
            zoom: 12,
          ),
          markers:
              placeCtrl.places
                  .map((p) => PlaceMarkerWidget.buildMarker(p))
                  .toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }
}
