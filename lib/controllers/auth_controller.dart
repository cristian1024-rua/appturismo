import 'package:get/get.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appturismo/repositories/auth_repository.dart';
import 'package:appturismo/controllers/user_controller.dart'; // Nuevo

/// Controlador de autenticación para la app de turismo usando GetX.
class AuthController extends GetxController {
  // Repositorio de autenticación inyectado
  final AuthRepository _authRepo = Get.find<AuthRepository>();

  /// Usuario autenticado (observable null si no hay sesión)
  final Rxn<models.User> user = Rxn<models.User>();

  /// Indicador de carga para operaciones de login/registro
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Escuchar cambios en el usuario desde el repositorio
    ever<models.User?>(_authRepo.user, (u) {
      user.value = u;
      // Nuevo: Cargar perfil de usuario cuando cambie el usuario
      if (u != null) {
        Get.find<UserController>().loadUserProfile(u.$id);
      }
    });

    // Cargar usuario actual al iniciar
    _loadUser();
  }

  /// Carga el usuario actual si ya hay sesión activa
  Future<void> _loadUser() async {
    if (user.value == null && await _authRepo.isLoggedIn()) {
      final me = await _authRepo.getCurrentUser();
      user.value = me;
    }
  }

  /// Registra un usuario y, si tiene éxito, navega a '/home'
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      final newUser = await _authRepo.register(
        email: email,
        password: password,
        name: name,
      );
      if (newUser != null) {
        // Nuevo: Crear perfil de usuario después del registro
        await Get.find<UserController>().createProfile(
          userId: newUser.$id,
          email: email,
          username: name,
        );
        Get.offAllNamed('/home');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Inicia sesión y, si tiene éxito, navega a '/home'
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      final success = await _authRepo.login(email: email, password: password);
      if (success) {
        // Nuevo: Cargar perfil de usuario después del login
        if (user.value != null) {
          await Get.find<UserController>().loadUserProfile(user.value!.$id);
        }
        Get.offAllNamed('/home');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Cierra sesión y regresa a '/login'
  Future<void> logout() async {
    await _authRepo.logout();
    user.value = null;
    // Nuevo: Limpiar perfil de usuario al cerrar sesión
    Get.find<UserController>().clearProfile();
    Get.offAllNamed('/login');
  }

  /// Indica si hay un usuario autenticado
  bool get isLoggedIn => user.value != null;
}
