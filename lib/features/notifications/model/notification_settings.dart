class NotificationSettings {
  final bool orderUpdates;
  final bool promoAlerts;
  final bool deliveryAlerts;
  final bool soundVibration;

  const NotificationSettings({
    this.orderUpdates = true,
    this.promoAlerts = true,
    this.deliveryAlerts = true,
    this.soundVibration = true,
  });

  NotificationSettings copyWith({
    bool? orderUpdates,
    bool? promoAlerts,
    bool? deliveryAlerts,
    bool? soundVibration,
  }) {
    return NotificationSettings(
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promoAlerts: promoAlerts ?? this.promoAlerts,
      deliveryAlerts: deliveryAlerts ?? this.deliveryAlerts,
      soundVibration: soundVibration ?? this.soundVibration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderUpdates': orderUpdates,
      'promoAlerts': promoAlerts,
      'deliveryAlerts': deliveryAlerts,
      'soundVibration': soundVibration,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      orderUpdates: json['orderUpdates'] as bool? ?? true,
      promoAlerts: json['promoAlerts'] as bool? ?? true,
      deliveryAlerts: json['deliveryAlerts'] as bool? ?? true,
      soundVibration: json['soundVibration'] as bool? ?? true,
    );
  }
}
