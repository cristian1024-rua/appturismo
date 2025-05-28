import 'package:flutter/material.dart';
import 'package:appturismo/controllers/place_controller.dart';

class CategorySelector extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const CategorySelector({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: initialValue ?? 'other',
      decoration: const InputDecoration(
        labelText: 'Categoría',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      items:
          PlaceController.availableCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category[0].toUpperCase() + category.substring(1)),
            );
          }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
