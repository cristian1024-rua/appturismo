// lib/controllers/place_controller.dart
import 'package:get/get.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/place_repository.dart';

class PlaceController extends GetxController {
  final PlaceRepository _placeRepository;
  RxList<Place> places = <Place>[].obs; // Lista observable de lugares
  RxBool isLoading = true.obs; // Indicador de carga
  RxString errorMessage = ''.obs; // Mensaje de error
  RxString searchQuery = ''.obs; // Para la barra de búsqueda

  PlaceController(this._placeRepository);

  @override
  void onInit() {
    super.onInit();
    fetchPlaces(); // Cargar lugares al iniciar el controlador
  }

  // Método para cargar lugares, opcionalmente con un query de búsqueda
  Future<void> fetchPlaces({String? query}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedPlaces = await _placeRepository.getPlaces(query: query);
      places.assignAll(fetchedPlaces); // Actualizar la lista observable
    } catch (e) {
      errorMessage.value = 'Error al cargar lugares: $e';
      print('PlaceController: Error fetching places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para añadir un nuevo lugar
  Future<void> addPlace(Place place) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final newPlace = await _placeRepository.addPlace(place: place);
      places.add(newPlace); // Añadir el nuevo lugar a la lista
      Get.snackbar('Éxito', 'Lugar añadido correctamente');
    } catch (e) {
      errorMessage.value = 'Error al añadir lugar: $e';
      Get.snackbar('Error', 'No se pudo añadir el lugar: $e');
      print('PlaceController: Error adding place: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para actualizar la búsqueda y recargar lugares
  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchPlaces(query: query);
  }
}
