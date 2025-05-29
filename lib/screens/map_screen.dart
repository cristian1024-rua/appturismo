import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/widgets/map_filters.dart'; // Añade esta importación

class MapScreen extends GetView<MapController> {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Lugares')),
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              options: MapOptions(
                initialCenter: controller.currentLatLng,
                initialZoom: controller.zoom.value,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.appturismo',
                ),
                MarkerLayer(markers: _buildMarkers(controller.places)),
              ],
            ),
          ),
          // Asegúrate de que MapFilters esté en un widget Positioned
          const Positioned(
            top: 8,
            left: 8,
            right: 8,
            child:
                MapFilters(), // Ahora MapFilters es reconocido como un widget
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  List<Marker> _buildMarkers(List<Place> places) {
    return places.map((place) {
      return Marker(
        point: LatLng(place.latitude, place.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => Get.toNamed('/detail', arguments: place),
          child: Icon(
            Icons.location_on,
            color: Get.theme.primaryColor,
            size: 40,
          ),
        ),
      );
    }).toList();
  }
}
