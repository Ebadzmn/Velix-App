import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'languages/sv_se.dart';
import 'languages/en_us.dart';
import 'languages/es_es.dart';
import 'languages/de_de.dart';
import 'languages/fr_fr.dart';
import 'languages/it_it.dart';
import 'languages/nl_nl.dart';
import 'languages/pt_pt.dart';

class LanguageModel {
  final String name;
  final String nativeName;
  final String flag;
  final Locale locale;

  const LanguageModel({
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.locale,
  });
}

class AppTranslations extends Translations {
  // Default Locale
  static const Locale defaultLocale = Locale('en', 'US');
  
  // Fallback Locale
  static const Locale fallbackLocale = Locale('en', 'US');

  // List of all 8 supported languages with flag and name
  static const List<LanguageModel> languages = [
    LanguageModel(name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', locale: Locale('sv', 'SE')),
    LanguageModel(name: 'English', nativeName: 'English', flag: '🇬🇧', locale: Locale('en', 'US')),
    LanguageModel(name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', locale: Locale('es', 'ES')),
    LanguageModel(name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', locale: Locale('de', 'DE')),
    LanguageModel(name: 'French', nativeName: 'Français', flag: '🇫🇷', locale: Locale('fr', 'FR')),
    LanguageModel(name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', locale: Locale('it', 'IT')),
    LanguageModel(name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', locale: Locale('nl', 'NL')),
    LanguageModel(name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', locale: Locale('pt', 'PT')),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'sv_SE': svSE,
    'en_US': enUS,
    'es_ES': esES,
    'de_DE': deDE,
    'fr_FR': frFR,
    'it_IT': itIT,
    'nl_NL': nlNL,
    'pt_PT': ptPT,
  };
}
