import 'package:appturismo/controllers/map_controller.dart';
import 'package:get/get.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceController extends GetxController {
  final PlaceRepository _repo;
  final RxList<Place> places = <Place>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxDouble searchRadius = 10.0.obs;

  static const List<String> availableCategories = [
    'restaurant',
    'hotel',
    'museum',
    'park',
    'beach',
    'monument',
    'other',
  ];

  PlaceController(this._repo);

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    fetchPlaces();
  }

  Future<void> fetchPlaces({
    double? userLat,
    double? userLon,
    String? searchQuery,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final docs = await _repo.getPlaces(
        userLat: userLat,
        userLon: userLon,
        searchQuery: searchQuery,
        categories:
            selectedCategories.isEmpty ? null : selectedCategories.toList(),
      );

      places.value = docs.map((doc) => Place.fromDocument(doc)).toList();

      // Actualizar marcadores en el mapa si está disponible
      try {
        final mapCtrl = Get.find<MapController>();
        mapCtrl.updateMarkers(places);
      } catch (_) {}
    } catch (e) {
      error.value = 'Error al cargar lugares: $e';
      print('Error fetching places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPlace(Place place) async {
    try {
      isLoading.value = true;
      error.value = '';
      final doc = await _repo.addPlace(place);
      final newPlace = Place.fromDocument(doc);
      places.add(newPlace);
      Get.snackbar(
        'Éxito',
        'Lugar agregado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al agregar lugar: $e';
      print('Error adding place: $e');
      Get.snackbar(
        'Error',
        'No se pudo agregar el lugar',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
