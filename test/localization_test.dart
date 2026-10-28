import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/localization/app_localizations.dart';
import 'package:spicy_eats/features/localization/controller/locale_provider.dart';
import 'package:spicy_eats/features/localization/model/app_language.dart';
import 'package:spicy_eats/features/localization/screens/language_selection_screen.dart';
import 'package:spicy_eats/features/localization/translations/app_translations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppLanguage Model Tests', () {
    test('supports expected languages including Arabic, German, Chinese, Urdu', () {
      final codes = AppLanguage.supportedLanguages.map((l) => l.code).toSet();
      expect(codes, containsAll(['en', 'ar', 'de', 'zh', 'ur', 'es', 'fr']));
    });

    test('correctly identifies RTL languages', () {
      expect(AppLanguage.fromCode('ar').isRtl, isTrue);
      expect(AppLanguage.fromCode('ur').isRtl, isTrue);
      expect(AppLanguage.fromCode('en').isRtl, isFalse);
      expect(AppLanguage.fromCode('de').isRtl, isFalse);
      expect(AppLanguage.fromCode('zh').isRtl, isFalse);
    });

    test('fallback returns English on unknown code', () {
      final lang = AppLanguage.fromCode('xyz_unknown');
      expect(lang.code, 'en');
    });
  });

  group('AppTranslations & AppLocalizations Tests', () {
    test('all supported languages have required key translations', () {
      const requiredKeys = [
        'account',
        'notifications',
        'language',
        'alerts',
        'preferences',
        'order_updates',
        'promotional_offers',
      ];

      for (final lang in AppLanguage.supportedLanguages) {
        final map = AppTranslations.translations[lang.code];
        expect(map, isNotNull, reason: 'Missing translation map for ${lang.code}');
        for (final key in requiredKeys) {
          expect(
            map!.containsKey(key),
            isTrue,
            reason: 'Missing key "$key" in language "${lang.code}"',
          );
        }
      }
    });

    test('parameter replacement works in translate', () {
      final loc = AppLocalizations(const Locale('en'));
      final translated = loc.translate('account', params: {'dummy': 'value'});
      expect(translated, 'Account');
    });
  });

  group('LocaleNotifier Tests', () {
    test('updates state and persists to SharedPreferences', () async {
      final notifier = LocaleNotifier(const Locale('en'));
      expect(notifier.state.languageCode, 'en');

      await notifier.setLocale('ar');
      expect(notifier.state.languageCode, 'ar');
      expect(notifier.currentLanguage.nativeName, 'العربية');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('spicy_eats_selected_language'), 'ar');
    });
  });

  group('LanguageSelectionScreen Widget Tests', () {
    testWidgets('renders all languages and filters on search', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            home: LanguageSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header and languages
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('English'), findsWidgets);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('Deutsch'), findsOneWidget);

      // Search for Arabic
      await tester.enterText(find.byType(TextField), 'Deutsch');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(InkWell, 'Deutsch'), findsOneWidget);
      expect(find.text('العربية'), findsNothing);
    });

    testWidgets('tapping a language selects it', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            home: LanguageSelectionScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on German (Deutsch)
      await tester.tap(find.text('Deutsch'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Deutsch'), findsWidgets);
    });
  });
}
