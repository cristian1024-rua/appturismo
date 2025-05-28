import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Rxn<Position> currentPosition = Rxn<Position>();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  late GoogleMapController mapCtrl;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxDouble zoomLevel = 12.0.obs;
  final RxSet<String> selectedFilters = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  void clearFilters() {
    selectedFilters.clear();
    final placeCtrl = Get.find<PlaceController>();
    updateMarkers(placeCtrl.places);
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }

    final placeCtrl = Get.find<PlaceController>();
    final filteredPlaces =
        selectedFilters.isEmpty
            ? placeCtrl.places
            : placeCtrl.places
                .where((p) => selectedFilters.contains(p.category))
                .toList();
    updateMarkers(filteredPlaces);
  }

  Future<void> _determinePosition() async {
    try {
      isLoading.value = true;
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        errorMessage.value =
            'Por favor activa tu GPS para una mejor experiencia';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Necesitamos permisos de ubicación';
          return;
        }
      }

      var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = p;

      if (mapCtrl != null) {
        mapCtrl.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(p.latitude, p.longitude),
            zoomLevel.value,
          ),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void updateMarkers(List<Place> places) {
    markers.clear();
    for (var place in places) {
      if (selectedFilters.isEmpty || selectedFilters.contains(place.category)) {
        markers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(
              title: place.title,
              snippet: place.description,
            ),
            onTap: () => Get.toNamed('/detail', arguments: place),
          ),
        );
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapCtrl = controller;
    if (currentPosition.value != null) {
      mapCtrl.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
          zoomLevel.value,
        ),
      );
    }
  }

  void onCameraMove(CameraPosition position) {
    zoomLevel.value = position.zoom;
  }

  Future<void> refreshLocation() => _determinePosition();
}
