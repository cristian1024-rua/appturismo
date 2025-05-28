import 'package:get/get.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/favorites_repository.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';

class FavoritesController extends GetxController {
  final _repo = Get.find<FavoritesRepository>();
  final _auth = Get.find<AuthController>();
  final _places = Get.find<PlaceController>();

  final RxList<Place> favorites = <Place>[].obs;
  final RxBool isLoading = false.obs;

  FavoritesController(FavoritesRepository find);

  @override
  void onInit() {
    super.onInit();
    ever(_auth.user, (_) => _load());
    ever(_places.places, (_) => _load());
    _load();
  }

  Future<void> _load() async {
    final u = _auth.user.value;
    if (u == null) return favorites.clear();
    isLoading.value = true;
    final ids = await _repo.getFavoritePlaceIds(u.$id);
    favorites.value =
        _places.places
            .where((d) => ids.contains(d.$id))
            .map((d) => Place.fromDocument(d))
            .toList();
    isLoading.value = false;
  }

  bool isFav(Place p) => favorites.any((f) => f.id == p.id);

  Future<void> toggle(Place p) async {
    final u = _auth.user.value;
    if (u == null) return;
    isLoading.value = true;
    if (isFav(p)) {
      await _repo.removeFavorite(u.$id, p.id);
    } else {
      await _repo.addFavorite(u.$id, p.id);
    }
    await _load();
  }
}
