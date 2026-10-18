import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_translations.dart';

class LocalizationController extends GetxController {
  final Rx<Locale> currentLocale = AppTranslations.defaultLocale.obs;

  LanguageModel get currentLanguage {
    return AppTranslations.languages.firstWhere(
      (lang) =>
          lang.locale.languageCode == currentLocale.value.languageCode &&
          (lang.locale.countryCode == null ||
              lang.locale.countryCode == currentLocale.value.countryCode),
      orElse: () => AppTranslations.languages[1], // default English
    );
  }

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }

  void showLanguageSelector(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF141521)
        : const Color(0xFFFFFFFF);
    final borderColor = isDark
        ? const Color(0xFF242536)
        : const Color(0xFFE5E7EB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark
        ? const Color(0xFF9EA3B0)
        : const Color(0xFF6B7280);
    const primaryColor = Color(0xFF9482FF);

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D0E15) : const Color(0xFFF9FAFC),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: labelColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'select_language'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose which language you want to use in the app',
              style: TextStyle(color: labelColor, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: AppTranslations.languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lang = AppTranslations.languages[index];
                  return Obx(() {
                    final isSelected =
                        currentLocale.value.languageCode ==
                        lang.locale.languageCode;
                    return GestureDetector(
                      onTap: () {
                        changeLanguage(lang.locale);
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withOpacity(0.12)
                              : cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? primaryColor : borderColor,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang.flag,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.name,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.nativeName,
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
