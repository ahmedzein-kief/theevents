import 'package:flutter/material.dart';

import '../core/network/api_endpoints/api_end_point.dart';
import '../core/services/shared_preferences_helper.dart';
import '../models/language_model.dart';
import 'api_response_handler.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  List<LanguageModel> _languages = [];
  bool _isLoadingLanguages = false;
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  Locale get locale => _locale;

  List<LanguageModel> get languages => _languages;

  bool get isLoadingLanguages => _isLoadingLanguages;

  void loadLocale() {
    final langCode = SecurePreferencesUtil.getLanguage();
    if (langCode != null && langCode.isNotEmpty) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      setLocale(const Locale('ar'));
    } else {
      setLocale(const Locale('en'));
    }
  }

  void setLocale(Locale locale) {
    // Validate that the locale is supported
    final isSupported = _languages.any((lang) => lang.code == locale.languageCode);
    if (!isSupported && _languages.isNotEmpty) {
      // If the locale is not supported, fall back to the first available language
      _locale = Locale(_languages.first.code ?? 'en');
    } else {
      _locale = locale;
    }
    SecurePreferencesUtil.saveLanguage(_locale.languageCode);
    notifyListeners();
  }

  /// Helper method to check if a language code is RTL
  bool isRTLLanguage(String languageCode) {
    const rtlLanguages = [
      'ar', // Arabic
      'ur', // Urdu
      'fa', // Persian/Farsi
      'he', // Hebrew
      'ps', // Pashto
      'sd', // Sindhi
      'ckb', // Central Kurdish
      'ku', // Kurdish
      'yi', // Yiddish
      'iw', // Hebrew (alternative code)
    ];
    return rtlLanguages.contains(languageCode);
  }

  /// Helper method to check if current locale is RTL
  bool get isCurrentLocaleRTL {
    return isRTLLanguage(_locale.languageCode);
  }

  // Get the current language's RTL setting from API data (fallback to helper method)
  bool get isRtl {
    final currentLang = getCurrentLanguage();
    // First try to get RTL info from API data
    if (currentLang?.langIsRtl != null) {
      return currentLang!.langIsRtl!;
    }
    // Fallback to our helper method if API data is not available
    return isRTLLanguage(_locale.languageCode);
  }

  Future<void> fetchLanguages(BuildContext context) async {
    if (_languages.isNotEmpty) return; // Already loaded

    _isLoadingLanguages = true;
    notifyListeners();

    try {
      print('Fetching languages from: ${ApiEndpoints.getAllActiveLanguages}');

      final response = await _apiResponseHandler.getRequest(
        ApiEndpoints.getAllActiveLanguages,
        context: context,
      );

      print('Language API response status: ${response.statusCode}');
      print('Language API response data: ${response.data}');

      if (response.statusCode == 200) {
        // The API returns a direct array, not a wrapped response
        if (response.data is List) {
          final languagesResponse = LanguagesResponse.fromJson(response.data);
          _languages = languagesResponse.languages ?? [];
          print(
            'Languages fetched successfully: ${_languages.length} languages',
          );

          // Sort languages by order if available
          _languages.sort((a, b) => (a.langOrder ?? 0).compareTo(b.langOrder ?? 0));

          // Print language details for debugging
          for (final lang in _languages) {
            print(
              'Language: ${lang.langName} (${lang.langLocale}) - RTL: ${lang.langIsRtl}',
            );
          }
        } else {
          print('Unexpected response format, using fallback languages');
          _languages = _getDefaultLanguages();
        }

        // Ensure we have at least English and Arabic as fallbacks
        if (_languages.isEmpty) {
          print('No languages found, using default languages');
          _languages = _getDefaultLanguages();
        }
      } else {
        // Fallback to default languages if API fails
        print(
          'API failed with status: ${response.statusCode}, using fallback languages',
        );
        _languages = _getDefaultLanguages();
      }
    } catch (e) {
      // Fallback to default languages if API fails
      print('Exception while fetching languages: $e');
      _languages = _getDefaultLanguages();
    }

    // Validate current locale after fetching languages
    _validateCurrentLocale();

    _isLoadingLanguages = false;
    notifyListeners();
  }

  void _validateCurrentLocale() {
    final isCurrentLocaleSupported = _languages.any((lang) => lang.code == _locale.languageCode);
    if (!isCurrentLocaleSupported && _languages.isNotEmpty) {
      // If current locale is not supported, switch to the first available language
      _locale = Locale(_languages.first.code ?? 'en');
      SecurePreferencesUtil.saveLanguage(_locale.languageCode);
      print(
        'Current locale not supported, switched to: ${_locale.languageCode}',
      );
    }
  }

  List<LanguageModel> _getDefaultLanguages() {
    return [
      LanguageModel(
        langId: 1,
        langName: 'English',
        langLocale: 'en',
        langCode: 'en_US',
        langFlag: 'us',
        langIsDefault: true,
        langOrder: 0,
        langIsRtl: false,
      ),
      LanguageModel(
        langId: 2,
        langName: 'العربية',
        langLocale: 'ar',
        langCode: 'ar',
        langFlag: 'ae',
        langIsDefault: false,
        langOrder: 1,
        langIsRtl: true,
      ),
    ];
  }

  LanguageModel? getCurrentLanguage() {
    return _languages.firstWhere(
      (lang) => lang.code == _locale.languageCode,
      orElse: () => _languages.first,
    );
  }
}
