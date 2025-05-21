// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/auth_controller.dart'; // Asegúrate de importar tu AuthController

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Obx(() {
              // Corrección: usar authController.isLoading
              return authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () {
                      authController.login(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    child: const Text('Iniciar Sesión'),
                  );
            }),
            const SizedBox(height: 16),
            Obx(() {
              // Corrección: usar authController.errorMessage
              return authController.errorMessage.value.isNotEmpty
                  ? Text(
                    authController.errorMessage.value, // Corrección
                    style: const TextStyle(color: Colors.red),
                  )
                  : const SizedBox.shrink();
            }),
            TextButton(
              onPressed: () {
                Get.toNamed('/register');
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
