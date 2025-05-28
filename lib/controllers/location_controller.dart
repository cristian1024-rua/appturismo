// lib/controllers/location_controller.dart
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  Rx<Position?> currentLocation = Rx<Position?>(null);
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndGetLocation();
  }

  Future<void> _checkAndGetLocation() async {
    isLoading.value = true;
    errorMessage.value = '';
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value =
          'Los servicios de ubicación están deshabilitados. Por favor, actívalos.';
      isLoading.value = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value =
            'Permiso de ubicación denegado. No podemos mostrar lugares cercanos.';
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value =
          'Permiso de ubicación denegado permanentemente. Por favor, habilítalo desde la configuración de la aplicación.';
      isLoading.value = false;
      return;
    }

    try {
      currentLocation.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
        'Ubicación actual: ${currentLocation.value?.latitude}, ${currentLocation.value?.longitude}',
      );
    } catch (e) {
      errorMessage.value = 'Error al obtener la ubicación: ${e.toString()}';
      print('Error al obtener ubicación: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLocation() => _checkAndGetLocation();
}
