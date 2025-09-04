// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';

import '../constants/app_translations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  // The core translation method
  // Fallback to key if translation not found
  String translate(String key) =>
      appTranslations[locale.languageCode]?[key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

// Support all languages: English, Arabic, Hindi, Russian, Chinese, and Urdu
  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'hi', 'ru', 'zh', 'ur'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

// --- YOUR NEW EXTENSION WITH `tr()` ---
// Added 'tr' method
extension AppLocalizationsExtension on BuildContext {
  String tr(String key) => AppLocalizations.of(this)?.translate(key) ?? key;
}
