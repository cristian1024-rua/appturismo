import 'package:appturismo/model/place_model.dart';
import 'package:get/get.dart';
import '../repositories/place_repository.dart';

class PlaceController extends GetxController {
  final PlaceRepository _repository;
  final RxList<Place> places = <Place>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final RxDouble searchRadius = 10.0.obs;

  PlaceController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  Future<void> fetchPlaces({
    String?
    searchQuery, // Cambiado de query a searchQuery para coincidir con el uso
    double? userLat,
    double? userLon,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final results = await _repository.getPlaces(
        query: searchQuery,
        categories: selectedCategories.isNotEmpty ? selectedCategories : null,
        userLat: userLat,
        userLon: userLon,
        radius: searchRadius.value,
      );

      if (results.isEmpty) {
        error.value = 'No se encontraron lugares turísticos';
      }

      places.value = results;
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

      final newPlace = await _repository.addPlace(place);
      places.add(newPlace);

      Get.back();
      Get.snackbar(
        'Éxito',
        'Lugar agregado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = 'Error al agregar lugar: $e';
      Get.snackbar(
        'Error',
        'No se pudo agregar el lugar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    fetchPlaces();
  }

  void updateSearchRadius(double value) {
    searchRadius.value = value;
    fetchPlaces();
  }

  void clearFilters() {
    selectedCategories.clear();
    searchQuery.value = '';
    searchRadius.value = 10.0;
    fetchPlaces();
  }

  static const List<String> availableCategories = [
    'restaurant',
    'hotel',
    'attraction',
    'other',
  ];
}
