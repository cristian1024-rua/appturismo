import 'package:appturismo/controllers/comment_controller.dart';
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appturismo/repositories/comment_repository.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Appwrite client
    final client = Client()
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);

    // Core services
    Get.put(Databases(client));
    Get.put(Account(client));

    // Repositories
    Get.lazyPut(() => CommentRepository(Get.find<Databases>()));
    Get.lazyPut(() => PlaceRepository(Get.find<Databases>()));

    // Controllers
    Get.lazyPut(() => MapController());
    Get.lazyPut(() => PlaceController(Get.find<PlaceRepository>()));
    Get.lazyPut(() => CommentController(Get.find<CommentRepository>()));
  }
}
