import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Rxn<Position> currentPosition = Rxn<Position>();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  late GoogleMapController mapCtrl;

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      isLoading.value = true;
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        errorMessage.value = 'Activa tu GPS';
        return;
      }
      var p = await Geolocator.getCurrentPosition();
      currentPosition.value = p;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onMapCreated(GoogleMapController c) => mapCtrl = c;

  void onTap(LatLng p) {
    Get.snackbar(
      'Coordenadas',
      'Lat ${p.latitude.toStringAsFixed(6)}, Lng ${p.longitude.toStringAsFixed(6)}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
