import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/localization/app_localizations.dart';
import 'package:spicy_eats/features/notifications/controller/notifications_controller.dart';
import 'package:spicy_eats/features/notifications/model/notification_item.dart';
import 'package:spicy_eats/features/notifications/model/notification_settings.dart';
import 'package:spicy_eats/features/notifications/repo/notifications_repository.dart';
import 'package:spicy_eats/features/notifications/screens/notifications_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Notifications Models Tests', () {
    test('NotificationItem JSON serialization round-trips correctly', () {
      final now = DateTime(2026, 10, 28, 12, 0, 0);
      final item = NotificationItem(
        id: 'n_1',
        title: 'Special Burger Discount',
        message: 'Get 30% off today only',
        type: NotificationType.promo,
        timestamp: now,
        isRead: false,
        data: {'voucher': 'BURGER30'},
      );

      final json = item.toJson();
      final restored = NotificationItem.fromJson(json);

      expect(restored.id, 'n_1');
      expect(restored.title, 'Special Burger Discount');
      expect(restored.type, NotificationType.promo);
      expect(restored.isRead, isFalse);
      expect(restored.data?['voucher'], 'BURGER30');
    });

    test('NotificationSettings JSON serialization round-trips correctly', () {
      const settings = NotificationSettings(
        orderUpdates: true,
        promoAlerts: false,
        deliveryAlerts: true,
        soundVibration: false,
      );

      final json = settings.toJson();
      final restored = NotificationSettings.fromJson(json);

      expect(restored.orderUpdates, isTrue);
      expect(restored.promoAlerts, isFalse);
      expect(restored.deliveryAlerts, isTrue);
      expect(restored.soundVibration, isFalse);
    });
  });

  group('NotificationsNotifier & Controller Tests', () {
    test('loads default seed notifications on first launch', () async {
      final repo = NotificationsRepository();
      final notifier = NotificationsNotifier(repo);

      // Wait for async _init
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(notifier.state.isNotEmpty, isTrue);
      expect(notifier.state.length, greaterThanOrEqualTo(3));
    });

    test('markAsRead and markAllAsRead update state properly', () async {
      final repo = NotificationsRepository();
      final notifier = NotificationsNotifier(repo);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final firstId = notifier.state.first.id;
      await notifier.markAsRead(firstId);

      expect(notifier.state.firstWhere((i) => i.id == firstId).isRead, isTrue);

      await notifier.markAllAsRead();
      expect(notifier.state.every((i) => i.isRead), isTrue);
    });

    test('deleteNotification and clearAll remove items', () async {
      final repo = NotificationsRepository();
      final notifier = NotificationsNotifier(repo);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final initialCount = notifier.state.length;
      final firstId = notifier.state.first.id;

      await notifier.deleteNotification(firstId);
      expect(notifier.state.length, initialCount - 1);
      expect(notifier.state.any((i) => i.id == firstId), isFalse);

      await notifier.clearAll();
      expect(notifier.state, isEmpty);
    });

    test('sendTestNotification adds an unread notification', () async {
      final repo = NotificationsRepository();
      final notifier = NotificationsNotifier(repo);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final prevCount = notifier.state.length;
      await notifier.sendTestNotification();

      expect(notifier.state.length, prevCount + 1);
      expect(notifier.state.first.isRead, isFalse);
      expect(notifier.state.first.title, contains('Pizza'));
    });

    test('NotificationSettingsNotifier toggles preferences', () async {
      final repo = NotificationsRepository();
      final notifier = NotificationSettingsNotifier(repo);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await notifier.togglePromoAlerts(false);
      expect(notifier.state.promoAlerts, isFalse);

      await notifier.toggleSoundVibration(false);
      expect(notifier.state.soundVibration, isFalse);
    });
  });

  group('NotificationsScreen Widget Tests', () {
    testWidgets('renders tabs and switch preferences', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
            ],
            home: NotificationsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Alerts tab and title
      expect(find.text('Notifications'), findsWidgets);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);

      // Verify filter chips exist
      expect(find.textContaining('All'), findsOneWidget);
      expect(find.textContaining('Unread'), findsOneWidget);

      // Tap on Preferences tab
      await tester.tap(find.text('Preferences'));
      await tester.pumpAndSettle();

      // Verify preference switches exist
      expect(find.text('Order Updates'), findsOneWidget);
      expect(find.text('Promotions & Discounts'), findsOneWidget);
      expect(find.text('Delivery Alerts'), findsOneWidget);
      expect(find.text('Sound & Alerts'), findsOneWidget);

      // Verify test notification button
      expect(find.text('Send Test Notification'), findsOneWidget);
      await tester.tap(find.text('Send Test Notification'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
