class LanguageModel {
  LanguageModel({
    this.langId,
    this.langName,
    this.langLocale,
    this.langCode,
    this.langFlag,
    this.langIsDefault,
    this.langOrder,
    this.langIsRtl,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      langId: json['lang_id'],
      langName: json['lang_name'],
      langLocale: json['lang_locale'],
      langCode: json['lang_code'],
      langFlag: json['lang_flag'],
      langIsDefault: json['lang_is_default'],
      langOrder: json['lang_order'],
      langIsRtl: json['lang_is_rtl'],
    );
  }

  final int? langId;
  final String? langName;
  final String? langLocale;
  final String? langCode;
  final String? langFlag;
  final bool? langIsDefault;
  final int? langOrder;
  final bool? langIsRtl;

  // Helper getters for backward compatibility
  int? get id => langId;

  String? get name => langName;

  String? get code => langLocale; // Use langLocale as the language code
  String? get flag => _getFlagEmoji(langFlag);

  bool? get isActive => true; // All languages in the response are active

  String? _getFlagEmoji(String? flagCode) {
    if (flagCode == null) return '🌐';

    // Convert country codes to flag emojis
    final flagMap = {
      'us': '🇺🇸',
      'ae': '🇦🇪',
      'in': '🇮🇳',
      'ru': '🇷🇺',
      'cn': '🇨🇳',
      'pk': '🇵🇰',
    };

    return flagMap[flagCode.toLowerCase()] ?? '🌐';
  }

  Map<String, dynamic> toJson() {
    return {
      'lang_id': langId,
      'lang_name': langName,
      'lang_locale': langLocale,
      'lang_code': langCode,
      'lang_flag': langFlag,
      'lang_is_default': langIsDefault,
      'lang_order': langOrder,
      'lang_is_rtl': langIsRtl,
    };
  }
}

class LanguagesResponse {
  LanguagesResponse({
    this.languages,
  });

  factory LanguagesResponse.fromJson(List<dynamic> json) {
    return LanguagesResponse(
      languages: json.map((x) => LanguageModel.fromJson(x)).toList(),
    );
  }

  final List<LanguageModel>? languages;

  // Helper getter for backward compatibility
  List<LanguageModel>? get data => languages;

  Map<String, dynamic> toJson() {
    return {
      'languages': languages?.map((x) => x.toJson()).toList(),
    };
  }
}
