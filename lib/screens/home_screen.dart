import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (authController.user.value == null) {
          return const Center(child: Text('No hay usuario autenticado.'));
        }

        final user = authController.user.value!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información del Usuario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('ID: ${user.$id}'),
              const SizedBox(height: 8),
              Text('Nombre: ${user.name}'),
              const SizedBox(height: 8),
              Text('Email: ${user.email}'),
            ],
          ),
        );
      }),
    );
  }
}
