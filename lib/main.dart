// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importa tus servicios
import 'services/appwrite_service.dart';
import 'services/location_service.dart';
import 'services/image_ai_service.dart';

// Importa tus repositorios
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/place_repository.dart';
import 'repositories/comment_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/theme_repository.dart';

// Importa tus controladores
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/place_controller.dart';
import 'controllers/comment_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/map_controller.dart';
import 'controllers/theme_controller.dart';

// Importa tus pantallas
import 'screens/splash_screen.dart';
import 'screens/places_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/map_screen.dart';
import 'screens/add_place_screen.dart';
import 'screens/home_screen.dart'; // Si usas esta pantalla para gestión de usuarios

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('main: WidgetsFlutterBinding inicializado.');

  try {
    await dotenv.load(fileName: ".env");
    print('main: Variables de entorno (.env) cargadas correctamente.');
  } catch (e) {
    print('main: ERROR CRÍTICO al cargar .env: $e');
    // Considera una alerta o salida controlada si el .env es esencial
  }

  // 1. Inicializar y registrar AppwriteService primero
  print('main: Registrando AppwriteService...');
  final AppwriteService appwriteService = AppwriteService();
  Get.put(appwriteService);
  print('main: AppwriteService registrado.');

  // 2. Registrar otros servicios
  print('main: Registrando LocationService...');
  Get.put(LocationService());
  print('main: LocationService registrado.');

  print('main: Registrando ImageAIService...');
  Get.put(ImageAIService());
  print('main: ImageAIService registrado.');

  // 3. Inicializar y registrar repositorios
  print('main: Registrando repositorios...');
  final authRepo = AuthRepository(appwriteService.account);
  // **** CORRECCIÓN AQUÍ ****
  final userRepo = UserRepository(
    repository: appwriteService.db,
  ); // Asegúrate de que el constructor coincide
  final placeRepo = PlaceRepository(appwriteService.db);
  final commentRepo = CommentRepository(appwriteService.db);
  final favoritesRepo = FavoritesRepository(appwriteService.db);
  final themeRepo = ThemeRepository();

  Get.put(authRepo);
  Get.put(userRepo);
  Get.put(placeRepo);
  Get.put(commentRepo);
  Get.put(favoritesRepo);
  Get.put(themeRepo);
  print('main: Repositorios registrados.');

  // 4. Inicializar y registrar controladores
  print('main: Registrando controladores...');
  Get.put(AuthController(authRepo));
  Get.put(UserController(repository: userRepo));
  Get.put(PlaceController(placeRepo));
  Get.put(CommentController(commentRepo));
  Get.put(FavoritesController(favoritesRepo));
  Get.put(MapController());
  Get.put(ThemeController(themeRepo));
  print('main: Controladores registrados.');

  print('main: Iniciando runApp...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Turismo App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        themeMode: themeController.themeMode.value,
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashPage()),
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/register', page: () => const RegisterScreen()),
          GetPage(name: '/home', page: () => const PlacesScreen()),
          GetPage(name: '/add', page: () => AddPlaceScreen()),
          GetPage(name: '/map', page: () => MapScreen()),
          GetPage(name: '/favorites', page: () => FavoritesScreen()),
          GetPage(name: '/profile', page: () => const ProfileScreen()),
          GetPage(name: '/users-management', page: () => const HomeScreen()),
        ],
      ),
    );
  }
}
