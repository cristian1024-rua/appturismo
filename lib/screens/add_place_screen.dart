// Tu código actual de AddPlaceScreen está bien en general,
// solo asegúrate de que los servicios que usa estén disponibles en Get.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart';
import 'package:appturismo/model/place_model.dart';
import 'package:appturismo/services/location_service.dart';
import 'package:appturismo/services/image_ai_service.dart';

class AddPlaceScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final placeCtrl = Get.find<PlaceController>();
  final authCtrl = Get.find<AuthController>();

  AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Lugar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: 'URL de Imagen'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latCtrl,
                      decoration: const InputDecoration(labelText: 'Latitud'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      keyboardType:
                          TextInputType.number, // Asegurar tipo de teclado
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lngCtrl,
                      decoration: const InputDecoration(labelText: 'Longitud'),
                      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                      keyboardType:
                          TextInputType.number, // Asegurar tipo de teclado
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text('Mi ubicación'),
                      onPressed: () async {
                        try {
                          final pos =
                              await Get.find<LocationService>()
                                  .getCurrentPosition();
                          _latCtrl.text = pos.latitude.toString();
                          _lngCtrl.text = pos.longitude.toString();
                        } catch (e) {
                          Get.snackbar('Error de ubicación', e.toString());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.image_search),
                      label: const Text('Detectar IA'),
                      onPressed: () async {
                        if (_imageCtrl.text.trim().isEmpty) {
                          Get.snackbar(
                            'Advertencia',
                            'Por favor, introduce una URL de imagen primero.',
                          );
                          return;
                        }
                        try {
                          Get.snackbar(
                            'Procesando',
                            'Analizando imagen con IA...',
                            showProgressIndicator: true,
                          );
                          final tags = await Get.find<ImageAIService>()
                              .analyzeImage(_imageCtrl.text.trim());
                          Get.back(); // Cierra el snackbar de progreso
                          if (tags.isNotEmpty) {
                            _nameCtrl.text = tags.first;
                            Get.snackbar(
                              'Éxito',
                              'Etiquetas encontradas: ${tags.join(', ')}',
                            );
                          } else {
                            Get.snackbar(
                              'Info',
                              'No se detectaron etiquetas en la imagen.',
                            );
                          }
                        } catch (e) {
                          Get.back(); // Cierra el snackbar de progreso en caso de error
                          Get.snackbar('Error IA', e.toString());
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = authCtrl.user.value;
                    if (user == null) {
                      Get.snackbar(
                        'Error',
                        'No estás autenticado',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    final newPlace = Place(
                      id: '', // Appwrite asignará el ID
                      name: _nameCtrl.text.trim(),
                      description: _descCtrl.text.trim(),
                      imageUrl: _imageCtrl.text.trim(),
                      latitude: double.parse(_latCtrl.text.trim()),
                      longitude: double.parse(_lngCtrl.text.trim()),
                      createdBy: user.$id,
                      title: '',
                    );
                    placeCtrl.addPlace(newPlace);
                    Get.back();
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
}
