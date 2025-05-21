import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final user = authCtrl.user.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body:
          user == null
              ? const Center(child: Text('No user data'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(user.username[0].toUpperCase()),
                    ),
                    const SizedBox(height: 12),
                    Text(user.username, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8),
                    Text(user.email),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => authCtrl.logout(),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
    );
  }
}

extension on User {
  get username => null;
}
