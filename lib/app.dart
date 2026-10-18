import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/localization_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/app_constants.dart';
import 'routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final localizationController = Get.put(LocalizationController());

    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: localizationController.currentLocale.value,
        fallbackLocale: AppTranslations.fallbackLocale,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.currentThemeMode,
      ),
    );
  }
}
