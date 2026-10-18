import 'package:flutter/material.dart';

class AppColors {
  // Light Palette
  static const lightBg = Color(0xFFF5F6FA);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE5E7EB);
  static const lightText = Color(0xFF111827);
  static const lightLabel = Color(0xFF6B7280);

  // Dark Palette
  static const darkBg = Color(0xFF0D0E15);
  static const darkCard = Color(0xFF141521);
  static const darkBorder = Color(0xFF242536);
  static const darkText = Color(0xFFFFFFFF);
  static const darkLabel = Color(0xFF9EA3B0);

  // Brand Accent Colors
  static const primary = Color(0xFF9482FF);
  static const green = Color(0xFF00E676);
  static const red = Color(0xFFFF3B30);
  static const amber = Color(0xFFFFA726);
}

class AppTheme {
  // Light Theme Definition
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.lightBg,
    cardColor: AppColors.lightCard,
    primaryColor: AppColors.primary,
    dividerColor: AppColors.lightBorder,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightText,
    ),
    useMaterial3: true,
  );

  // Dark Theme Definition
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.darkBg,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.primary,
    dividerColor: AppColors.darkBorder,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
    ),
    useMaterial3: true,
  );
}
