// lib/screens/places_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/place_controller.dart';
import 'package:appturismo/controllers/auth_controller.dart'; // Necesitas AuthController para cerrar sesión
import 'package:appturismo/widgets/place_card.dart'; // Asume que tienes un PlaceCard widget

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final PlaceController placeCtrl = Get.find<PlaceController>();
  final AuthController authCtrl =
      Get.find<AuthController>(); // Obtener AuthController
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    placeCtrl.fetchPlaces(); // Cargar lugares al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authCtrl.logout(); // Llamar al método logout del AuthController
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.toNamed('/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar lugares...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                placeCtrl.onSearchChanged(
                  value,
                ); // Llamar a la función de búsqueda
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (placeCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Corrección: usar placeCtrl.errorMessage
              if (placeCtrl.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text('Error: ${placeCtrl.errorMessage.value}'),
                ); // Corrección
              }
              if (placeCtrl.places.isEmpty) {
                return const Center(child: Text('No hay lugares disponibles.'));
              }
              return ListView.builder(
                itemCount: placeCtrl.places.length,
                itemBuilder: (context, index) {
                  final place = placeCtrl.places[index];
                  return PlaceCard(place: place);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
