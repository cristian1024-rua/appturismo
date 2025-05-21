import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appturismo/services/location_service.dart';

class MapController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      currentPosition.value = await _locationService.getCurrentPosition();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error de ubicación',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
