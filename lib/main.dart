import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:appturismo/services/appwrite_client.dart' as AppwriteClient;
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appwrite/appwrite.dart';

// Repos y Ctrl
import 'package:appturismo/repositories/auth_repository.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:appturismo/repositories/storage_repository.dart';
import 'package:appturismo/repositories/favorites_repository.dart';
import 'package:appturismo/repositories/comment_repository.dart';

import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/controllers/comment_controller.dart';
import 'package:appturismo/controllers/map_controller.dart';

// Pantallas
import 'package:appturismo/screens/splash_screen.dart';
import 'package:appturismo/screens/login_screen.dart';
import 'package:appturismo/screens/register_screen.dart';
import 'package:appturismo/screens/places_screen.dart';
import 'package:appturismo/screens/add_place_screen.dart';
import 'package:appturismo/screens/place_detail_screen.dart';
import 'package:appturismo/screens/map_screen.dart';
import 'package:appturismo/screens/favorites_screen.dart';
import 'package:appturismo/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  AppwriteClient.client
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectId)
      .setSelfSigned(status: true);

  final db = Databases(AppwriteClient.client);
  final storage = Storage(AppwriteClient.client);

  // Repos
  Get.lazyPut(() => AuthRepository(), fenix: true);
  Get.lazyPut(() => PlaceRepository(db), fenix: true);
  Get.lazyPut(
    () => StorageRepository(storage, bucketId: AppwriteConstants.bucketId),
    fenix: true,
  );
  Get.lazyPut(() => FavoritesRepository(db), fenix: true);
  Get.lazyPut(() => CommentRepository(db), fenix: true);

  // Ctrl
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => LocationController(), fenix: true);
  Get.lazyPut(() => PlaceController(Get.find()), fenix: true);
  Get.lazyPut(() => FavoritesController(Get.find()), fenix: true);
  Get.lazyPut(() => CommentController(Get.find()), fenix: true);
  Get.lazyPut(() => MapController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turismo App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.tealAccent),
      themeMode: ThemeMode.system,
      home: Obx(() {
        if (auth.isLoading.value) return const SplashScreen();
        return auth.isLoggedIn ? const PlacesScreen() : const LoginScreen();
      }),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/places', page: () => const PlacesScreen()),
        GetPage(name: '/add', page: () => AddPlaceScreen()),
        GetPage(
          name: '/detail',
          page: () => PlaceDetailScreen(place: Get.arguments),
        ),
        GetPage(name: '/map', page: () => MapScreen()),
        GetPage(name: '/favorites', page: () => FavoritesScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}
