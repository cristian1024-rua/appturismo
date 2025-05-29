import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:appwrite/appwrite.dart';

// Servicios y Constantes
import 'package:appturismo/core/constants/appwrite_constants.dart';

// Repositories
import 'package:appturismo/repositories/auth_repository.dart';
import 'package:appturismo/repositories/place_repository.dart';
import 'package:appturismo/repositories/storage_repository.dart';
import 'package:appturismo/repositories/favorites_repository.dart';
import 'package:appturismo/repositories/comment_repository.dart';
import 'package:appturismo/repositories/user_repository.dart';

// Controllers
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/controllers/comment_controller.dart';
import 'package:appturismo/controllers/map_controller.dart';
import 'package:appturismo/controllers/user_controller.dart';

// Screens
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
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();

    // Inicializar Appwrite
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
    Get.put<PlaceRepository>(PlaceRepository(databases), permanent: true);
    Get.put<StorageRepository>(
      StorageRepository(storage, bucketId: AppwriteConstants.bucketId),
      permanent: true,
    );
    Get.put<FavoritesRepository>(
      FavoritesRepository(databases),
      permanent: true,
    );
    Get.put<CommentRepository>(CommentRepository(databases), permanent: true);
    Get.put<UserRepository>(
      UserRepository(databases, storage),
      permanent: true,
    );

    // Controllers
    Get.put<AuthController>(AuthController(), permanent: true); // Cambiado
    Get.put<LocationController>(LocationController(), permanent: true);
    Get.put<PlaceController>(
      PlaceController(Get.find<PlaceRepository>()),
      permanent: true,
    );
    Get.put<FavoritesController>(
      FavoritesController(Get.find<FavoritesRepository>()),
      permanent: true,
    );
    Get.put<CommentController>(
      CommentController(Get.find<CommentRepository>()),
      permanent: true,
    );
    Get.put<MapController>(MapController(), permanent: true);
    Get.put<UserController>(
      UserController(Get.find<UserRepository>()),
      permanent: true,
    );

    runApp(const MyApp());
  } catch (e) {
    print('Error al inicializar la aplicación: $e');
    runApp(const ErrorApp());
  }
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
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.tealAccent,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Obx(() {
        if (auth.isLoading.value) return const SplashScreen();
        return auth.isLoggedIn ? const PlacesScreen() : const LoginScreen();
      }),
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/places',
          page: () => const PlacesScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/add',
          page: () => const AddPlaceScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/detail',
          page: () => PlaceDetailScreen(place: Get.arguments),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/map',
          page: () => const MapScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/favorites',
          page: () => const FavoritesScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Error al iniciar la aplicación',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  main();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
