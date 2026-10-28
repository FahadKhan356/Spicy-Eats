import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/localization/app_localizations.dart';
import 'package:spicy_eats/features/notifications/controller/notifications_controller.dart';
import 'package:spicy_eats/features/notifications/model/notification_item.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  static const String routename = '/notifications';

  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, unread, order, promo

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatRelativeTime(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return context.tr('just_now');
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.orange;
      case NotificationType.delivery:
        return Colors.blue;
      case NotificationType.promo:
        return Colors.pink;
      case NotificationType.system:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.restaurant;
      case NotificationType.delivery:
        return Icons.delivery_dining;
      case NotificationType.promo:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.notifications_active;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final settings = ref.watch(notificationSettingsProvider);
    final isRtl = context.isRtl;

    final filteredList = notifications.where((item) {
      if (_selectedFilter == 'unread') return !item.isRead;
      if (_selectedFilter == 'order') {
        return item.type == NotificationType.order ||
            item.type == NotificationType.delivery;
      }
      if (_selectedFilter == 'promo') {
        return item.type == NotificationType.promo;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('notification_center'),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onSelected: (value) async {
                if (value == 'mark_read') {
                  await ref.read(notificationsProvider.notifier).markAllAsRead();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr('mark_all_read')),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else if (value == 'clear_all') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(context.tr('clear_all')),
                      content: const Text('Are you sure you want to clear all notifications?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(context.tr('cancel')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            context.tr('delete'),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(notificationsProvider.notifier).clearAll();
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mark_read',
                  child: Row(
                    children: [
                      const Icon(Icons.done_all, size: 20, color: Colors.black87),
                      const SizedBox(width: 12),
                      Text(context.tr('mark_all_read')),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_sweep_outlined, size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(context.tr('clear_all'), style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange[800],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.orange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.tr('alerts')),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: context.tr('preferences')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Alerts List
          Column(
            children: [
              // Filter Chips
              Container(
                height: 54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip('all', context.tr('all'), notifications.length),
                    _buildFilterChip('unread', context.tr('unread'), unreadCount),
                    _buildFilterChip(
                      'order',
                      context.tr('orders'),
                      notifications
                          .where((i) =>
                              i.type == NotificationType.order ||
                              i.type == NotificationType.delivery)
                          .length,
                    ),
                    _buildFilterChip(
                      'promo',
                      context.tr('promos'),
                      notifications
                          .where((i) => i.type == NotificationType.promo)
                          .length,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Notification cards
              Expanded(
                child: filteredList.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final typeColor = _getTypeColor(item.type);
                          final typeIcon = _getTypeIcon(item.type);

                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(notificationsProvider.notifier)
                                  .deleteNotification(item.id);
                            },
                            child: InkWell(
                              onTap: () async {
                                if (!item.isRead) {
                                  await ref
                                      .read(notificationsProvider.notifier)
                                      .markAsRead(item.id);
                                }
                                if (context.mounted) {
                                  _showNotificationDetails(context, item);
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: item.isRead
                                        ? Colors.grey.withValues(alpha: 0.15)
                                        : typeColor.withValues(alpha: 0.35),
                                    width: item.isRead ? 1 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Leading icon badge
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: typeColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        typeIcon,
                                        color: typeColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.title,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: item.isRead
                                                        ? FontWeight.w600
                                                        : FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatRelativeTime(
                                                    context, item.timestamp),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.message,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Unread dot
                                    if (!item.isRead) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: BoxDecoration(
                                          color: typeColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // Tab 2: Settings & Preferences
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                    SwitchListTile(
                      activeThumbColor: Colors.orange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_long, color: Colors.orange),
                      ),
                      title: Text(
                        context.tr('order_updates'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        context.tr('order_updates_desc'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      value: settings.orderUpdates,
                      onChanged: (val) {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .toggleOrderUpdates(val);
                      },
                    ),
                    const Divider(height: 1, indent: 64),
                    SwitchListTile(
                      activeThumbColor: Colors.orange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_offer_outlined, color: Colors.pink),
                      ),
                      title: Text(
                        context.tr('promotional_offers'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        context.tr('promotional_offers_desc'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      value: settings.promoAlerts,
                      onChanged: (val) {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .togglePromoAlerts(val);
                      },
                    ),
                    const Divider(height: 1, indent: 64),
                    SwitchListTile(
                      activeThumbColor: Colors.orange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delivery_dining, color: Colors.blue),
                      ),
                      title: Text(
                        context.tr('delivery_alerts'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        context.tr('delivery_alerts_desc'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      value: settings.deliveryAlerts,
                      onChanged: (val) {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .toggleDeliveryAlerts(val);
                      },
                    ),
                    const Divider(height: 1, indent: 64),
                    SwitchListTile(
                      activeThumbColor: Colors.orange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.volume_up_outlined, color: Colors.purple),
                      ),
                      title: Text(
                        context.tr('sound_vibration'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Text(
                        context.tr('sound_vibration_desc'),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      value: settings.soundVibration,
                      onChanged: (val) {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .toggleSoundVibration(val);
                      },
                    ),
                  ],
                ),
              ),
            ),

              const SizedBox(height: 24),

              // Test notification trigger
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(notificationsProvider.notifier)
                      .sendTestNotification();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Text(context.tr('test_notification_sent')),
                          ],
                        ),
                        backgroundColor: Colors.green[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    _tabController.animateTo(0);
                  }
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: Text(context.tr('send_test_notification')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, int count) {
    final isSelected = _selectedFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text('$label ($count)'),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        selectedColor: Colors.orange,
        backgroundColor: const Color(0xFFF1F3F5),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.transparent,
          ),
        ),
        onSelected: (_) => setState(() => _selectedFilter = key),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.tr('no_notifications'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('no_notifications_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                await ref
                    .read(notificationsProvider.notifier)
                    .sendTestNotification();
              },
              icon: const Icon(Icons.add_alert, size: 18),
              label: Text(context.tr('send_test_notification')),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange[800],
                side: BorderSide(color: Colors.orange[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final typeColor = _getTypeColor(item.type);
        final typeIcon = _getTypeIcon(item.type);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatRelativeTime(context, item.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(context.tr('close')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
