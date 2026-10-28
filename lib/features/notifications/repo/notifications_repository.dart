import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/notifications/model/notification_item.dart';
import 'package:spicy_eats/features/notifications/model/notification_settings.dart';

class NotificationsRepository {
  static const String _notificationsKey = 'spicy_eats_user_notifications';
  static const String _settingsKey = 'spicy_eats_notifications_settings';

  Future<List<NotificationItem>> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_notificationsKey);
      if (data == null) {
        // Seed initial notifications for immediate realistic experience
        final seedList = _getSeedNotifications();
        await saveNotifications(seedList);
        return seedList;
      }
      final List decoded = jsonDecode(data) as List;
      return decoded
          .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      return _getSeedNotifications();
    }
  }

  Future<void> saveNotifications(List<NotificationItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_notificationsKey, encoded);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  Future<NotificationSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_settingsKey);
      if (data == null) return const NotificationSettings();
      return NotificationSettings.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
      return const NotificationSettings();
    }
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
    } catch (e) {
      debugPrint('Error saving notification settings: $e');
    }
  }

  List<NotificationItem> _getSeedNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 'notif_1',
        title: 'Order #SP-8492 Out for Delivery! 🛵',
        message: 'Your rider Muhammad is on the way with your hot meal. Track live on the map!',
        type: NotificationType.delivery,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        data: {'orderId': 'SP-8492'},
      ),
      NotificationItem(
        id: 'notif_2',
        title: '50% OFF Weekend Deal! 🔥',
        message: 'Craving spicy burgers? Use voucher code SPICY50 to get flat 50% discount on selected restaurants today.',
        type: NotificationType.promo,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        data: {'code': 'SPICY50'},
      ),
      NotificationItem(
        id: 'notif_3',
        title: 'Order #SP-8310 Delivered 🎉',
        message: 'Your order from StreetGrill was delivered successfully. Enjoy your delicious food!',
        type: NotificationType.order,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
        data: {'orderId': 'SP-8310'},
      ),
      NotificationItem(
        id: 'notif_4',
        title: 'Welcome to Spicy Eats! 🌶️',
        message: 'Explore the best restaurants, fast food, and desi cuisines delivered right to your door.',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}
