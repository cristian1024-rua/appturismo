// lib/controllers/user_controller.dart
import 'package:appwrite/models.dart'; // Si User es un modelo de Appwrite
import 'package:get/get.dart';
import 'package:appturismo/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository
  _userRepository; // Renombrado a _userRepository para consistencia
  RxList<Document> users =
      <Document>[].obs; // Asumo que son documentos de Appwrite
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  UserController({required UserRepository repository})
    : _userRepository = repository; // Usamos el nombre 'repository'

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      users.value =
          await _userRepository.getAllUsers(); // Usa el método correcto
    } catch (e) {
      errorMessage.value = 'Error al cargar usuarios: $e';
      print('UserController: Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _userRepository.addUser(userData); // Usa el método correcto
      fetchAllUsers(); // Recargar la lista
      Get.snackbar('Éxito', 'Usuario añadido correctamente');
    } catch (e) {
      errorMessage.value = 'Error al añadir usuario: $e';
      Get.snackbar('Error', 'No se pudo añadir el usuario: $e');
      print('UserController: Error adding user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _userRepository.updateUser(
        userId,
        userData,
      ); // Usa el método correcto
      fetchAllUsers(); // Recargar la lista
      Get.snackbar('Éxito', 'Usuario actualizado correctamente');
    } catch (e) {
      errorMessage.value = 'Error al actualizar usuario: $e';
      Get.snackbar('Error', 'No se pudo actualizar el usuario: $e');
      print('UserController: Error updating user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _userRepository.deleteUser(userId); // Usa el método correcto
      fetchAllUsers(); // Recargar la lista
      Get.snackbar('Éxito', 'Usuario eliminado correctamente');
    } catch (e) {
      errorMessage.value = 'Error al eliminar usuario: $e';
      Get.snackbar('Error', 'No se pudo eliminar el usuario: $e');
      print('UserController: Error deleting user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
