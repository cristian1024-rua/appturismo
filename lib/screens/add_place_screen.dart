import 'dart:io';
import 'package:appturismo/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/repositories/storage_repository.dart';

class AddPlaceScreen extends StatelessWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceController>();
    final auth = Get.find<AuthController>();
    final storage = Get.find<StorageRepository>();
    final picker = ImagePicker();

    final formKey = GlobalKey<FormState>();
    final tTitle = TextEditingController();
    final tDesc = TextEditingController();
    XFile? picked;

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
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: tDesc,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Seleccionar Imagen'),
                onPressed: () async {
                  picked = await picker.pickImage(source: ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.my_location),
                label: const Text('Usar mi ubicación'),
                onPressed: () async {
                  var loc =
                      Get.find<LocationController>().currentLocation.value;
                  if (loc != null) {
                    tDesc.text +=
                        '\n(${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)})';
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  var user = auth.user.value;
                  if (user == null) return;

                  String imageUrl = '';
                  if (picked != null) {
                    var f = await storage.uploadImage(File(picked!.path));
                    imageUrl =
                        'https://fra.cloud.appwrite.io/v1/storage/buckets/${storage.bucketId}/files/${f.$id}/view';
                  }

                  var newPlace = Place(
                    id: '',
                    title: tTitle.text.trim(),
                    description: tDesc.text.trim(),
                    imageUrl: imageUrl,
                    latitude: 0,
                    longitude: 0,
                    createdBy: user.$id,
                    name: '',
                  );
                  await placeCtrl.addPlace(newPlace);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
