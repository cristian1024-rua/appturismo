import 'package:appturismo/model/user_model.dart';
import 'package:get/get.dart';
import '../repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  UserController(this._userRepository);

  // Cargar perfil de usuario
  Future<void> loadUserProfile(String userId) async {
    try {
      isLoading.value = true;
      currentUser.value = await _userRepository.getUserProfile(userId);
    } catch (e) {
      print('Error loading user profile: $e');
      Get.snackbar('Error', 'No se pudo cargar el perfil');
    } finally {
      isLoading.value = false;
    }
  }

  // Crear perfil de usuario
  Future<void> createProfile({
    required String userId,
    required String email,
    required String username,
  }) async {
    try {
      isLoading.value = true;
      final user = UserModel(id: userId, username: username, email: email);
      currentUser.value = await _userRepository.createUserProfile(user);
    } catch (e) {
      print('Error creating user profile: $e');
      Get.snackbar('Error', 'No se pudo crear el perfil');
    } finally {
      isLoading.value = false;
    }
  }

  // Actualizar perfil
  Future<void> updateProfile({String? username, String? bio}) async {
    if (currentUser.value == null) return;

    try {
      isLoading.value = true;
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;

      currentUser.value = await _userRepository.updateUserProfile(
        currentUser.value!.id,
        updates,
      );
      Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'No se pudo actualizar el perfil');
    } finally {
      isLoading.value = false;
    }
  }

  // Limpiar perfil
  void clearProfile() {
    currentUser.value = null;
  }

  // Actualizar imagen de perfil
  Future<void> updateProfileImage(XFile image) async {
    if (currentUser.value == null) return;

    try {
      isLoading.value = true;
      final bytes = await image.readAsBytes();
      final imageUrl = await _userRepository.uploadProfileImage(
        currentUser.value!.id,
        bytes,
        image.name,
      );

      await updateProfile(username: currentUser.value!.username);
      Get.snackbar('Éxito', 'Imagen de perfil actualizada');
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar('Error', 'No se pudo actualizar la imagen');
    } finally {
      isLoading.value = false;
    }
  }
}
