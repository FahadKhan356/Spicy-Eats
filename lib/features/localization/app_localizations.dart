import 'package:flutter/material.dart';
import 'package:spicy_eats/features/localization/model/app_language.dart';
import 'package:spicy_eats/features/localization/translations/app_translations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static List<Locale> get supportedLocales =>
      AppLanguage.supportedLanguages.map((lang) => lang.locale).toList();

  String translate(String key, {Map<String, String>? params}) {
    final langCode = locale.languageCode;
    final langMap = AppTranslations.translations[langCode] ??
        AppTranslations.translations['en']!;
    var text = langMap[key] ?? AppTranslations.translations['en']?[key] ?? key;

    if (params != null) {
      params.forEach((paramKey, value) {
        text = text.replaceAll('{$paramKey}', value);
      });
    }

    return text;
  }

  bool get isRtl => AppLanguage.fromCode(locale.languageCode).isRtl;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguage.supportedLanguages
        .any((lang) => lang.code == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key, {Map<String, String>? params}) {
    return AppLocalizations.of(this).translate(key, params: params);
  }

  bool get isRtl => AppLocalizations.of(this).isRtl;
}
