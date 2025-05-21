// lib/controllers/auth_controller.dart
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:appturismo/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs; // Añadido
  RxString errorMessage = ''.obs; // Añadido

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    isLoading.value = true; // Empieza a cargar
    errorMessage.value = '';
    try {
      user.value = await _authRepository.getCurrentUser();
      print('AuthController: Current user: ${user.value?.email}');
    } catch (e) {
      errorMessage.value = 'Error al verificar usuario: $e';
      print('AuthController: Error checking current user: $e');
      user.value = null;
    } finally {
      isLoading.value = false; // Termina de cargar
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true; // Empieza a cargar
    errorMessage.value = '';
    try {
      await _authRepository.login(email, password);
      await _checkCurrentUser();
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = e.toString(); // Asigna el error para mostrarlo en UI
      Get.snackbar('Error de inicio de sesión', e.toString());
      print('AuthController: Login failed: $e');
    } finally {
      isLoading.value = false; // Termina de cargar
    }
  }

  Future<void> register(String email, String password, String name) async {
    isLoading.value = true; // Empieza a cargar
    errorMessage.value = '';
    try {
      await _authRepository.register(email, password, name);
      await _checkCurrentUser();
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = e.toString(); // Asigna el error para mostrarlo en UI
      Get.snackbar('Error de registro', e.toString());
      print('AuthController: Registration failed: $e');
    } finally {
      isLoading.value = false; // Termina de cargar
    }
  }

  Future<void> logout() async {
    isLoading.value = true; // Empieza a cargar
    errorMessage.value = '';
    try {
      await _authRepository.logout();
      user.value = null;
      Get.offAllNamed('/login');
      Get.snackbar('Sesión cerrada', 'Has cerrado sesión correctamente');
    } catch (e) {
      errorMessage.value = e.toString(); // Asigna el error para mostrarlo en UI
      Get.snackbar('Error al cerrar sesión', e.toString());
      print('AuthController: Logout failed: $e');
    } finally {
      isLoading.value = false; // Termina de cargar
    }
  }

  bool get isLoggedIn => user.value != null;
  String? get currentUserId => user.value?.$id;
  String? get currentUserEmail => user.value?.email;
  String? get currentUserName => user.value?.name;
}
