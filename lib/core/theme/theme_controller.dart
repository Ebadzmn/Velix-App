import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // 0: System standard, 1: Bright (Light), 2: Dark
  final selectedThemeIndex = 2.obs; // Default to Dark

  ThemeMode get currentThemeMode {
    switch (selectedThemeIndex.value) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
      default:
        return ThemeMode.dark;
    }
  }

  void setThemeIndex(int index) {
    selectedThemeIndex.value = index;
    Get.changeThemeMode(currentThemeMode);
  }
}
