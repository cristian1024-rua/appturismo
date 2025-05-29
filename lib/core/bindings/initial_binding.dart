import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import '../constants/appwrite_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/place_controller.dart';
import '../../controllers/map_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/place_repository.dart';
import '../../repositories/comment_repository.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Appwrite client
    final client =
        Client()
          ..setEndpoint(AppwriteConstants.endpoint)
          ..setProject(AppwriteConstants.projectId)
          ..setSelfSigned(status: true);

    // Core services
    final databases = Databases(client);
    final storage = Storage(client);

    // Repositories
    Get.put<AuthRepository>(AuthRepository(), permanent: true);
    Get.put<UserRepository>(
      UserRepository(databases, storage),
      permanent: true,
    );
    Get.put<PlaceRepository>(PlaceRepository(databases), permanent: true);
    Get.put<CommentRepository>(CommentRepository(databases), permanent: true);

    // Controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(
      UserController(Get.find<UserRepository>()),
      permanent: true,
    );
    Get.put<PlaceController>(
      PlaceController(Get.find<PlaceRepository>()),
      permanent: true,
    );
    Get.put<MapController>(MapController(), permanent: true);
    Get.put<CommentController>(
      CommentController(Get.find<CommentRepository>()),
      permanent: true,
    );
  }
}
