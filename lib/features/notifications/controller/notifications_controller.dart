import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/notifications/model/notification_item.dart';
import 'package:spicy_eats/features/notifications/model/notification_settings.dart';
import 'package:spicy_eats/features/notifications/repo/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository();
});

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  final NotificationsRepository _repository;

  NotificationsNotifier(this._repository) : super([]) {
    _init();
  }

  Future<void> _init() async {
    final list = await _repository.loadNotifications();
    state = list;
  }

  Future<void> markAsRead(String id) async {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
    await _repository.saveNotifications(state);
  }

  Future<void> markAllAsRead() async {
    state = [
      for (final item in state) item.copyWith(isRead: true),
    ];
    await _repository.saveNotifications(state);
  }

  Future<void> deleteNotification(String id) async {
    state = state.where((item) => item.id != id).toList();
    await _repository.saveNotifications(state);
  }

  Future<void> clearAll() async {
    state = [];
    await _repository.saveNotifications(state);
  }

  Future<void> addNotification(NotificationItem item) async {
    state = [item, ...state];
    await _repository.saveNotifications(state);
  }

  Future<void> sendTestNotification() async {
    final now = DateTime.now();
    final testItem = NotificationItem(
      id: 'test_${now.millisecondsSinceEpoch}',
      title: 'Hot & Fresh Pizza arriving soon! 🍕',
      message: 'Your test notification has been received successfully. Spicy Eats notifications are 100% operational!',
      type: NotificationType.delivery,
      timestamp: now,
      isRead: false,
      data: {'test': true},
    );
    await addNotification(testItem);
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  final repo = ref.watch(notificationsRepositoryProvider);
  return NotificationsNotifier(repo);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider);
  return items.where((i) => !i.isRead).length;
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final NotificationsRepository _repository;

  NotificationSettingsNotifier(this._repository)
      : super(const NotificationSettings()) {
    _init();
  }

  Future<void> _init() async {
    final settings = await _repository.loadSettings();
    state = settings;
  }

  Future<void> toggleOrderUpdates(bool value) async {
    state = state.copyWith(orderUpdates: value);
    await _repository.saveSettings(state);
  }

  Future<void> togglePromoAlerts(bool value) async {
    state = state.copyWith(promoAlerts: value);
    await _repository.saveSettings(state);
  }

  Future<void> toggleDeliveryAlerts(bool value) async {
    state = state.copyWith(deliveryAlerts: value);
    await _repository.saveSettings(state);
  }

  Future<void> toggleSoundVibration(bool value) async {
    state = state.copyWith(soundVibration: value);
    await _repository.saveSettings(state);
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  final repo = ref.watch(notificationsRepositoryProvider);
  return NotificationSettingsNotifier(repo);
});
