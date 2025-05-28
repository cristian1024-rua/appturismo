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
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      // Si se obtiene el usuario, la sesión está activa
      Get.off(() => const PlacesScreen());
    } catch (e) {
      // Si ocurre un error, no hay sesión activa
      Get.off(() => const LoginScreen());
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
