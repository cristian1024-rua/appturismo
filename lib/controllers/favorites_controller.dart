import 'package:get/get.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/favorites_repository.dart';
import 'package:appturismo/controllers/auth_controller.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository _repo;
  final RxList<Place> favorites = <Place>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  FavoritesController(this._repo);

  String get _userId {
    final auth = Get.find<AuthController>();
    final userId = auth.user.value?.$id;
    if (userId == null) throw 'Usuario no autenticado';
    return userId;
  }

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<AuthController>().user, (_) => fetchFavorites());
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      isLoading.value = true;
      error.value = '';
      final docs = await _repo.getFavorites(_userId);
      favorites.value = docs.map((doc) => Place.fromDocument(doc)).toList();
    } catch (e) {
      error.value = 'Error al cargar favoritos: $e';
      print('Error fetching favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Añadimos este método que faltaba
  Future<void> refreshFavorites() async {
    return fetchFavorites();
  }

  Future<void> addFavorite(Place place) async {
    try {
      await _repo.addFavorite(_userId, place);
      if (!favorites.any((p) => p.id == place.id)) {
        favorites.add(place);
      }
    } catch (e) {
      error.value = 'Error al agregar favorito: $e';
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String placeId) async {
    try {
      await _repo.removeFavorite(_userId, placeId);
      favorites.removeWhere((place) => place.id == placeId);
    } catch (e) {
      error.value = 'Error al eliminar favorito: $e';
      print('Error removing favorite: $e');
      rethrow;
    }
  }

  bool isFavorite(String placeId) {
    return favorites.any((place) => place.id == placeId);
  }
}
