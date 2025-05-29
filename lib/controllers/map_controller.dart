import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:appturismo/model/place_model.dart';

class MapController extends GetxController {
  // Observables
  final RxBool isLoading = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxList<Place> places = <Place>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxDouble zoom = 13.0.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  // Cambié de privado (_getCurrentLocation) a público (getCurrentLocation)
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Error',
          'El servicio de ubicación está deshabilitado',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Error',
            'Permisos de ubicación denegados',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Error',
          'Los permisos de ubicación están permanentemente denegados',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      currentPosition.value = position;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al obtener la ubicación: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateZoom(double newZoom) {
    zoom.value = newZoom;
  }

  void addPlace(Place place) {
    places.add(place);
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    updatePlaces();
  }

  void clearFilters() {
    selectedFilters.clear();
    updatePlaces();
  }

  void updatePlaces() {
    // Aquí implementarías la lógica para filtrar lugares
    // según los filtros seleccionados
  }

  LatLng get currentLatLng {
    return currentPosition.value != null
        ? LatLng(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        )
        : const LatLng(1.2076, -77.2638); // Ubicación por defecto
  }
}
