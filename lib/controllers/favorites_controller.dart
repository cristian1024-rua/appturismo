import 'package:get/get.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/favorites_repository.dart';
import 'package:appturismo/controllers/auth_controller.dart'; // Necesitamos el usuario autenticado
import 'package:appturismo/controllers/place_controller.dart'; // Para obtener los detalles de los lugares

class FavoritesController extends GetxController {
  final FavoritesRepository _favoritesRepository;
  final AuthController _authController = Get.find<AuthController>();
  final PlaceController _placeController =
      Get.find<PlaceController>(); // Para resolver los PlaceModel
  final RxList<Place> favorites = <Place>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  FavoritesController(this._favoritesRepository);

  @override
  void onInit() {
    super.onInit();
    // Escuchar cambios en el usuario autenticado para recargar favoritos
    ever(_authController.user, (_) => _loadFavorites());
    // Escuchar cambios en los lugares para actualizar la lista de favoritos si un lugar cambia/se elimina
    ever(_placeController.places, (_) => _loadFavorites());
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final currentUser = _authController.user.value;
    if (currentUser == null) {
      favorites.clear();
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      final favoritePlaceIds = await _favoritesRepository.getFavoritePlaceIds(
        currentUser.$id,
      );
      // Filtrar los lugares disponibles para obtener solo los favoritos
      final allPlaces =
          _placeController
              .places; // Obtener todos los lugares del PlaceController
      favorites.value =
          allPlaces
              .where((place) => favoritePlaceIds.contains(place.id))
              .toList();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error al cargar favoritos',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(Place place) {
    return favorites.any((favPlace) => favPlace.id == place.id);
  }

  Future<void> toggleFavorite(Place place) async {
    final currentUser = _authController.user.value;
    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'Debes iniciar sesión para añadir a favoritos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true; // Podrías usar un isLoading más granular por ítem
    error.value = '';
    try {
      if (isFavorite(place)) {
        await _favoritesRepository.removeFavorite(currentUser.$id, place.id);
        favorites.removeWhere((favPlace) => favPlace.id == place.id);
        Get.snackbar(
          'Éxito',
          '${place.name} eliminado de favoritos',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _favoritesRepository.addFavorite(currentUser.$id, place.id);
        favorites.add(place);
        Get.snackbar(
          'Éxito',
          '${place.name} añadido a favoritos',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error al actualizar favorito',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
