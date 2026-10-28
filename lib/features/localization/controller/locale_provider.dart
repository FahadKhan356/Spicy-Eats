import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/localization/model/app_language.dart';

const String _prefLanguageCodeKey = 'spicy_eats_selected_language';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier([Locale? initialLocale]) : super(initialLocale ?? const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefLanguageCodeKey);
      if (savedCode != null && savedCode.isNotEmpty) {
        state = Locale(savedCode);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (state.languageCode == languageCode) return;
    state = Locale(languageCode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLanguageCodeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  AppLanguage get currentLanguage => AppLanguage.fromCode(state.languageCode);
}

final appLocaleProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final currentLanguageProvider = Provider<AppLanguage>((ref) {
  final locale = ref.watch(appLocaleProvider);
  return AppLanguage.fromCode(locale.languageCode);
});
