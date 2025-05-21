// lib/repositories/auth_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AuthRepository {
  final Account _account;

  AuthRepository(this._account);

  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      // Si el error es 401 (Unauthorized), significa que no hay usuario logueado.
      if (e.code == 401) {
        return null;
      }
      print('AuthRepository: Error getting current user: ${e.message}');
      rethrow;
    } catch (e) {
      print('AuthRepository: Unknown error getting current user: $e');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _account.createEmailSession(email: email, password: password);
    } on AppwriteException catch (e) {
      print('AuthRepository: Login failed: ${e.message}');
      throw Exception('Inicio de sesión fallido: ${e.message}');
    } catch (e) {
      print('AuthRepository: Unknown login error: $e');
      throw Exception('Error desconocido al iniciar sesión.');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      // Opcional: iniciar sesión automáticamente después del registro
      await login(email, password);
    } on AppwriteException catch (e) {
      print('AuthRepository: Registration failed: ${e.message}');
      throw Exception('Registro fallido: ${e.message}');
    } catch (e) {
      print('AuthRepository: Unknown registration error: $e');
      throw Exception('Error desconocido al registrarse.');
    }
  }

  Future<void> logout() async {
    try {
      // Primero, verifica si hay una sesión activa para cerrar.
      // Si getCurrentUser() devuelve null, no hay sesión activa y no hay nada que cerrar.
      final User? currentUser = await getCurrentUser();
      if (currentUser != null) {
        await _account.deleteSession(sessionId: 'current');
      } else {
        print('AuthRepository: No active session to logout.');
      }
    } on AppwriteException catch (e) {
      // Maneja errores específicos si aún así ocurre algo
      print('AuthRepository: Logout failed: ${e.message}');
      throw Exception('Error al cerrar sesión: ${e.message}');
    } catch (e) {
      print('AuthRepository: Unknown logout error: $e');
      throw Exception('Error desconocido al cerrar sesión.');
    }
  }
}

extension on Account {
  createEmailSession({required String email, required String password}) {}
}
