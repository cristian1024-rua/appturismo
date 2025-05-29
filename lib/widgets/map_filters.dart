import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/map_controller.dart';

class MapFilters extends StatelessWidget {
  const MapFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapCtrl = Get.find<MapController>();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8),
                const Text('Filtros'),
                const Spacer(),
                TextButton(
                  onPressed: mapCtrl.clearFilters,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'Restaurantes',
                      value: 'restaurant',
                      mapCtrl: mapCtrl,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Hoteles',
                      value: 'hotel',
                      mapCtrl: mapCtrl,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Atracciones',
                      value: 'attraction',
                      mapCtrl: mapCtrl,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Otros',
                      value: 'other',
                      mapCtrl: mapCtrl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    required MapController mapCtrl,
  }) {
    return FilterChip(
      label: Text(label),
      selected: mapCtrl.selectedFilters.contains(value),
      onSelected: (selected) => mapCtrl.toggleFilter(value),
    );
  }
}
