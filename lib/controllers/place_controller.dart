import 'package:get/get.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceController extends GetxController {
  final PlaceRepository _repo;
  final RxList<Place> places = <Place>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  PlaceController(this._repo);

  @override
  void onInit() {
    super.onInit();
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
      );
      places.value = docs.map((doc) => Place.fromDocument(doc)).toList();
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
    } catch (e) {
      error.value = 'Error al agregar lugar: $e';
      print('Error adding place: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
