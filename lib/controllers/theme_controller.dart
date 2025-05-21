import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appturismo/repositories/theme_repository.dart';

class ThemeController extends GetxController {
  final ThemeRepository _repository;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    _repository.saveThemeMode(themeMode.value);
  }

  Future<void> loadTheme() async {
    final savedTheme = await _repository.getSavedThemeMode();
    themeMode.value = savedTheme;
  }
}
