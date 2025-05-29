import 'package:get/get.dart';
import 'package:appturismo/controllers/map_controller.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
  }
}
