// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/auth_controller.dart'; // Asegúrate de importar tu AuthController

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
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
                      authController.register(
                        emailController.text,
                        passwordController.text,
                        nameController.text,
                      );
                    },
                    child: const Text('Registrarse'),
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
                Get.back(); // Volver a la pantalla de login
              },
              child: const Text('¿Ya tienes cuenta? Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
