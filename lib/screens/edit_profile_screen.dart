import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appturismo/controllers/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final userCtrl = Get.find<UserController>();
  XFile? profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar datos actuales del usuario
    final user = userCtrl.currentUser.value;
    if (user != null) {
      nameController.text = user.username;
      bioController.text = user.bio ?? '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, // Optimizar tamaño de imagen
      imageQuality: 85, // Comprimir imagen
    );
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'El nombre no puede estar vacío',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Primero actualizar la imagen si se seleccionó una nueva
      if (profileImage != null) {
        await userCtrl.updateProfileImage(profileImage!);
      }

      // Luego actualizar el resto del perfil
      await userCtrl.updateProfile(
        username: nameController.text.trim(),
        bio: bioController.text.trim(),
      );

      Get.back();
      Get.snackbar(
        'Éxito',
        'Perfil actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el perfil',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error actualizando perfil: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        profileImage != null
                            ? FileImage(File(profileImage!.path))
                            : userCtrl.currentUser.value?.avatarUrl != null
                            ? NetworkImage(
                                  userCtrl.currentUser.value!.avatarUrl!,
                                )
                                as ImageProvider
                            : null,
                    child:
                        (profileImage == null &&
                                userCtrl.currentUser.value?.avatarUrl == null)
                            ? const Icon(Icons.person, size: 60)
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Biografía',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveChanges,
                child: Text(
                  isLoading ? 'Guardando...' : 'Guardar Cambios',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}
