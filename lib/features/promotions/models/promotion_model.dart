class PromotionModel {
  final int id;
  final DateTime? createdAt;
  final String? restaurantId;
  final String title;
  final String? description;
  final String kind; // 'percent', 'fixed', 'free_delivery', 'bogo', 'combo'
  final double value;
  final double minOrder;
  final double? maxDiscount;
  final String? code;
  final String? bannerImage;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final int? usageLimit;
  final int usedCount;
  final int perUserLimit;
  final bool isActive;

  PromotionModel({
    required this.id,
    this.createdAt,
    this.restaurantId,
    required this.title,
    this.description,
    required this.kind,
    required this.value,
    this.minOrder = 0,
    this.maxDiscount,
    this.code,
    this.bannerImage,
    this.startsAt,
    this.endsAt,
    this.usageLimit,
    this.usedCount = 0,
    this.perUserLimit = 1,
    this.isActive = true,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      restaurantId: json['restaurant_id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      kind: json['kind']?.toString() ?? 'percent',
      value: (json['value'] is num) ? (json['value'] as num).toDouble() : double.tryParse(json['value']?.toString() ?? '0') ?? 0.0,
      minOrder: (json['min_order'] is num) ? (json['min_order'] as num).toDouble() : double.tryParse(json['min_order']?.toString() ?? '0') ?? 0.0,
      maxDiscount: json['max_discount'] != null ? ((json['max_discount'] is num) ? (json['max_discount'] as num).toDouble() : double.tryParse(json['max_discount'].toString())) : null,
      code: json['code']?.toString(),
      bannerImage: json['banner_image']?.toString(),
      startsAt: json['starts_at'] != null ? DateTime.tryParse(json['starts_at'].toString()) : null,
      endsAt: json['ends_at'] != null ? DateTime.tryParse(json['ends_at'].toString()) : null,
      usageLimit: json['usage_limit'] != null ? int.tryParse(json['usage_limit'].toString()) : null,
      usedCount: json['used_count'] != null ? int.tryParse(json['used_count'].toString()) ?? 0 : 0,
      perUserLimit: json['per_user_limit'] != null ? int.tryParse(json['per_user_limit'].toString()) ?? 1 : 1,
      isActive: json['is_active'] == true || json['is_active']?.toString() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'restaurant_id': restaurantId,
      'title': title,
      'description': description,
      'kind': kind,
      'value': value,
      'min_order': minOrder,
      'max_discount': maxDiscount,
      'code': code,
      'banner_image': bannerImage,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'usage_limit': usageLimit,
      'used_count': usedCount,
      'per_user_limit': perUserLimit,
      'is_active': isActive,
    };
  }

  /// Calculates discount based on subtotal and delivery fee.
  double calculateDiscount({required double subtotal, double deliveryFee = 0.0}) {
    if (!isActive) return 0.0;
    if (subtotal < minOrder) return 0.0;

    double calculated = 0.0;
    switch (kind) {
      case 'percent':
        calculated = (subtotal * value) / 100.0;
        if (maxDiscount != null && maxDiscount! > 0 && calculated > maxDiscount!) {
          calculated = maxDiscount!;
        }
        break;
      case 'fixed':
        calculated = value;
        if (calculated > subtotal) {
          calculated = subtotal;
        }
        break;
      case 'free_delivery':
        calculated = deliveryFee;
        break;
      case 'bogo':
      case 'combo':
        calculated = value > 0 ? value : 0.0;
        break;
      default:
        calculated = 0.0;
    }
    return calculated > 0 ? calculated : 0.0;
  }

  /// Human-friendly display label (e.g. "20% OFF", "Rs 100 OFF", "Free Delivery")
  String get badgeLabel {
    switch (kind) {
      case 'percent':
        return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}% OFF';
      case 'fixed':
        return 'Rs ${value.toStringAsFixed(0)} OFF';
      case 'free_delivery':
        return 'Free Delivery';
      case 'bogo':
        return 'BOGO Deal';
      case 'combo':
        return 'Combo Offer';
      default:
        return title;
    }
  }

  /// Check whether promotion is currently valid with respect to dates and limits
  (bool, String?) checkValidity({
    required double subtotal,
    String? currentRestaurantId,
  }) {
    if (!isActive) {
      return (false, 'This promotion is currently inactive.');
    }

    final now = DateTime.now();
    if (startsAt != null && now.isBefore(startsAt!)) {
      return (false, 'This promotion has not started yet.');
    }

    if (endsAt != null && now.isAfter(endsAt!)) {
      return (false, 'This promotion has expired.');
    }

    if (usageLimit != null && usageLimit! > 0 && usedCount >= usageLimit!) {
      return (false, 'This coupon has reached its maximum usage limit.');
    }

    if (subtotal < minOrder) {
      return (false, 'Minimum order amount for this coupon is Rs ${minOrder.toStringAsFixed(0)}.');
    }

    if (restaurantId != null &&
        restaurantId!.isNotEmpty &&
        currentRestaurantId != null &&
        currentRestaurantId.isNotEmpty &&
        restaurantId != currentRestaurantId) {
      return (false, 'This coupon is valid only at specific participating restaurants.');
    }

    return (true, null);
  }
}
