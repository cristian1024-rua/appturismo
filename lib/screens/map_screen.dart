import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/model/place_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mapCtrl = Get.find<MapController>();
    final placeCtrl = Get.find<PlaceController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Interactivo')),
      body: Obx(() {
        if (mapCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (mapCtrl.errorMessage.value.isNotEmpty) {
          return Center(child: Text(mapCtrl.errorMessage.value));
        }
        var pos = mapCtrl.currentPosition.value!;
        var markers =
            placeCtrl.places.map((doc) {
              var p = Place.fromDocument(doc);
              return Marker(
                markerId: MarkerId(p.id),
                position: LatLng(p.latitude, p.longitude),
                infoWindow: InfoWindow(title: p.title),
              );
            }).toSet();

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(pos.latitude, pos.longitude),
            zoom: 12,
          ),
          onMapCreated: mapCtrl.onMapCreated,
          myLocationEnabled: true,
          markers: markers,
          onTap: mapCtrl.onTap,
        );
      }),
    );
  }
}
