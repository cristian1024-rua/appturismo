import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get/get.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';

class AuthRepository extends GetxService {
  late final Account _account;
  final Rxn<models.User> user = Rxn<models.User>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final client =
        Client()
          ..setEndpoint(AppwriteConstants.endpoint)
          ..setProject(AppwriteConstants.projectId)
          ..setSelfSigned(status: true);
    _account = Account(client);
    _loadCurrentUser();
  }

  Future<models.User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      final newUser = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      user.value = await _account.get();
      return newUser;
    } on AppwriteException catch (e) {
      Get.snackbar('Error al registrarse', e.message ?? e.toString());
      return null;
    } catch (e) {
      Get.snackbar('Error inesperado', e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      user.value = await _account.get();
      return true;
    } on AppwriteException catch (e) {
      Get.snackbar('Error al iniciar sesión', e.message ?? e.toString());
      return false;
    } catch (e) {
      Get.snackbar('Error inesperado', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}
    user.value = null;
  }

  Future<bool> isLoggedIn() async {
    try {
      await _account.get();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadCurrentUser() async {
    if (await isLoggedIn()) {
      try {
        user.value = await _account.get();
      } catch (_) {
        user.value = null;
      }
    }
  }

  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }
}
