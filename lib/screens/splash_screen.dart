import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appturismo/core/constants/appwrite_constants.dart';
import 'package:appturismo/screens/login_screen.dart';
import 'package:appturismo/screens/places_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final client =
      Client()
        ..setEndpoint(AppwriteConstants.endpoint)
        ..setProject(AppwriteConstants.projectId)
        ..setSelfSigned(status: true);

  late final Account account;

  @override
  void initState() {
    super.initState();
    account = Account(client);
    // Usar Future.delayed para evitar el error de navegación
    Future.delayed(const Duration(milliseconds: 500), _checkSession);
  }

  Future<void> _checkSession() async {
    try {
      // Intentar obtener la sesión actual
      final session = await account.getSession(sessionId: 'current');
      if (session.current) {
        // Obtener el usuario actual
        final user = await account.get();
        print('Usuario autenticado: ${user.name}');
        // Navegar a PlacesScreen usando offAll para limpiar la pila de navegación
        await Get.offAll(() => const PlacesScreen());
      } else {
        throw Exception('No hay sesión activa');
      }
    } catch (e) {
      print('Error en _checkSession: $e');
      // Navegar a LoginScreen usando offAll para limpiar la pila de navegación
      await Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Cargando...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
