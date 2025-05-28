import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/place_controller.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeCtrl = Get.find<PlaceController>();

    return ExpansionTile(
      title: const Text('Filtros de Búsqueda'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Distancia'),
              Slider(
                value: placeCtrl.searchRadius.value,
                min: 1,
                max: 50,
                divisions: 49,
                label: '${placeCtrl.searchRadius.value.round()} km',
                onChanged: (value) => placeCtrl.searchRadius.value = value,
              ),
              const SizedBox(height: 16),
              const Text('Categorías'),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Restaurantes'),
                    selected: placeCtrl.selectedCategories.contains(
                      'restaurant',
                    ),
                    onSelected:
                        (selected) => placeCtrl.toggleCategory('restaurant'),
                  ),
                  FilterChip(
                    label: const Text('Hoteles'),
                    selected: placeCtrl.selectedCategories.contains('hotel'),
                    onSelected: (selected) => placeCtrl.toggleCategory('hotel'),
                  ),
                  FilterChip(
                    label: const Text('Atracciones'),
                    selected: placeCtrl.selectedCategories.contains(
                      'attraction',
                    ),
                    onSelected:
                        (selected) => placeCtrl.toggleCategory('attraction'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
