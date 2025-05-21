import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/controllers/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  final ThemeController controller;

  const ThemeToggle({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: controller.themeMode.value == ThemeMode.dark,
        onChanged: controller.toggleTheme,
      ),
    );
  }
}
