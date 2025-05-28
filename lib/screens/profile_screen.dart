// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:appturismo/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Obx(() {
        final User? u = auth.user.value;
        if (u == null) return const Center(child: Text('No autenticado'));
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal[100],
                child: Text(
                  u.name.isNotEmpty
                      ? u.name[0].toUpperCase()
                      : u.email[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 16),
              Text(u.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(u.email, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => auth.logout(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
