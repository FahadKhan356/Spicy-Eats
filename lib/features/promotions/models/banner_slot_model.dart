class BannerSlotModel {
  final String id;
  final String? positionId;
  final String? restaurantId;
  final String? bannerImageUrl;
  final String? bannerTitle;
  final String? redirectUrl;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? price;

  BannerSlotModel({
    required this.id,
    this.positionId,
    this.restaurantId,
    this.bannerImageUrl,
    this.bannerTitle,
    this.redirectUrl,
    this.status,
    this.startDate,
    this.endDate,
    this.price,
  });

  factory BannerSlotModel.fromJson(Map<String, dynamic> json) {
    return BannerSlotModel(
      id: json['id']?.toString() ?? '',
      positionId: json['position_id']?.toString(),
      restaurantId: json['restaurant_id']?.toString(),
      bannerImageUrl: json['banner_image_url']?.toString(),
      bannerTitle: json['banner_title']?.toString(),
      redirectUrl: json['redirect_url']?.toString(),
      status: json['status']?.toString(),
      startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date'].toString()) : null,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date'].toString()) : null,
      price: json['price'] != null ? ((json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price'].toString())) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position_id': positionId,
      'restaurant_id': restaurantId,
      'banner_image_url': bannerImageUrl,
      'banner_title': bannerTitle,
      'redirect_url': redirectUrl,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'price': price,
    };
  }
}

/// Unified banner item for the Home top carousel.
/// Works with both live Supabase banners and bundled fallback assets.
class HomeBannerItem {
  final String id;
  final String imageUrl;
  final bool isNetwork;
  final String? title;
  final String? restaurantId;
  final String? promoCode;
  final String? discountTag;

  const HomeBannerItem({
    required this.id,
    required this.imageUrl,
    this.isNetwork = true,
    this.title,
    this.restaurantId,
    this.promoCode,
    this.discountTag,
  });

  factory HomeBannerItem.fromBannerSlot(BannerSlotModel slot) {
    return HomeBannerItem(
      id: slot.id,
      imageUrl: slot.bannerImageUrl ?? '',
      isNetwork: true,
      title: slot.bannerTitle,
      restaurantId: slot.restaurantId,
    );
  }

  factory HomeBannerItem.fromAsset(String assetPath, {String? id}) {
    return HomeBannerItem(
      id: id ?? assetPath,
      imageUrl: assetPath,
      isNetwork: false,
      title: null,
    );
  }
}
