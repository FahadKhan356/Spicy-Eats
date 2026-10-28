import 'package:flutter/material.dart';

class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRtl;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.isRtl = false,
  });

  Locale get locale => Locale(code);

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
      isRtl: false,
    ),
    AppLanguage(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
      isRtl: true,
    ),
    AppLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
      isRtl: false,
    ),
    AppLanguage(
      code: 'zh',
      name: 'Chinese',
      nativeName: '中文 (简体)',
      flag: '🇨🇳',
      isRtl: false,
    ),
    AppLanguage(
      code: 'ur',
      name: 'Urdu',
      nativeName: 'اردو',
      flag: '🇵🇰',
      isRtl: true,
    ),
    AppLanguage(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      isRtl: false,
    ),
    AppLanguage(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
      isRtl: false,
    ),
    AppLanguage(
      code: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: '🇮🇹',
      isRtl: false,
    ),
    AppLanguage(
      code: 'tr',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
      isRtl: false,
    ),
  ];

  static AppLanguage fromCode(String? code) {
    if (code == null) return supportedLanguages.first;
    return supportedLanguages.firstWhere(
      (lang) => lang.code.toLowerCase() == code.toLowerCase(),
      orElse: () => supportedLanguages.first,
    );
  }
}
