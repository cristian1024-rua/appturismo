import 'dart:io';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/storage_repository.dart';
import 'package:appturismo/widgets/category_selector.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final formKey = GlobalKey<FormState>();
  final tTitle = TextEditingController();
  final tDesc = TextEditingController();
  XFile? picked;
  String selectedCategory = 'other';
  double? latitude;
  double? longitude;

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceController>();
    final auth = Get.find<AuthController>();
    final storage = Get.find<StorageRepository>();
    final picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Lugar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tTitle,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tDesc,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              CategorySelector(
                initialValue: selectedCategory,
                onChanged: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Seleccionar Imagen'),
                onPressed: () async {
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      setState(() {
                        picked = image;
                      });
                    }
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'No se pudo seleccionar la imagen: $e',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              if (picked != null) ...[
                const SizedBox(height: 8),
                Image.file(
                  File(picked!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Usar mi ubicación'),
                onPressed: () async {
                  var loc =
                      Get.find<LocationController>().currentLocation.value;
                  if (loc != null) {
                    setState(() {
                      latitude = loc.latitude;
                      longitude = loc.longitude;
                      tDesc.text +=
                          '\nUbicación: (${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)})';
                    });
                  } else {
                    Get.snackbar(
                      'Error',
                      'No se pudo obtener la ubicación',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final user = auth.user.value;
                  if (user == null) {
                    Get.snackbar(
                      'Error',
                      'Debe iniciar sesión para agregar lugares',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  try {
                    String imageUrl = '';
                    if (picked != null) {
                      final f = await storage.uploadImage(File(picked!.path));
                      imageUrl =
                          'https://fra.cloud.appwrite.io/v1/storage/buckets/${storage.bucketId}/files/${f.$id}/view';
                    }

                    final newPlace = Place(
                      id: '',
                      title: tTitle.text.trim(),
                      description: tDesc.text.trim(),
                      imageUrl: imageUrl,
                      latitude: latitude ?? 0,
                      longitude: longitude ?? 0,
                      createdBy: user.$id,
                      name: tTitle.text.trim(),
                      category: selectedCategory,
                    );

                    await placeCtrl.addPlace(newPlace);
                    Get.back();
                    Get.snackbar(
                      'Éxito',
                      'Lugar agregado correctamente',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'No se pudo agregar el lugar: $e',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tTitle.dispose();
    tDesc.dispose();
    super.dispose();
  }
}
