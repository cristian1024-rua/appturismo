import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/favorites_controller.dart';
import 'package:appturismo/widgets/favorites_list.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: FavoritesListWidget(),
    );
  }
}
