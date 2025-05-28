import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceController extends GetxController {
  final _repo = Get.find<PlaceRepository>();
  final RxList<Document> places = <Document>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  PlaceController(PlaceRepository find);

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
    isLoading.value = true;
    try {
      final docs = await _repo.getPlaces(
        userLat: userLat,
        userLon: userLon,
        searchQuery: searchQuery,
      );
      places.value = docs;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPlace(Place p) async {
    isLoading.value = true;
    await _repo.addPlace(place: p);
    await fetchPlaces();
  }
}
