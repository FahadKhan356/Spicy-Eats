import 'package:flutter/foundation.dart';
import 'package:spicy_eats/features/promotions/models/banner_slot_model.dart';
import 'package:spicy_eats/features/promotions/models/promotion_model.dart';
import 'package:spicy_eats/main.dart';

class CouponValidationResult {
  final bool isValid;
  final String message;
  final PromotionModel? promotion;
  final double discountAmount;

  const CouponValidationResult({
    required this.isValid,
    required this.message,
    this.promotion,
    this.discountAmount = 0.0,
  });
}

class PromotionRepository {
  /// Fetches active promotions from Supabase.
  /// If [restaurantId] is provided, returns promotions specific to that restaurant plus sitewide ones.
  Future<List<PromotionModel>> fetchActivePromotions({String? restaurantId}) async {
    try {
      final nowIso = DateTime.now().toIso8601String();
      var query = supabaseClient
          .from('promotions')
          .select()
          .eq('is_active', true)
          .lte('starts_at', nowIso);

      final response = await query;
      final list = (response as List).map((row) => PromotionModel.fromJson(row)).toList();

      final now = DateTime.now();
      return list.where((p) {
        // Filter out expired promotions
        if (p.endsAt != null && now.isAfter(p.endsAt!)) {
          return false;
        }
        // If restaurant filter is given, keep restaurant-specific or sitewide promos
        if (restaurantId != null && restaurantId.isNotEmpty) {
          return p.restaurantId == null || p.restaurantId!.isEmpty || p.restaurantId == restaurantId;
        }
        return true;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching promotions: $e');
      return [];
    }
  }

  /// Validates a coupon code entered by the user.
  Future<CouponValidationResult> validateCoupon({
    required String code,
    required double subtotal,
    String? restaurantId,
    required String userId,
    double deliveryFee = 0.0,
  }) async {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      return const CouponValidationResult(
        isValid: false,
        message: 'Please enter a coupon code.',
      );
    }

    try {
      final response = await supabaseClient
          .from('promotions')
          .select()
          .ilike('code', cleanCode)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) {
        return const CouponValidationResult(
          isValid: false,
          message: 'Invalid promo code. Please check and try again.',
        );
      }

      final promo = PromotionModel.fromJson(response);

      // 1. Basic validity check
      final (valid, reason) = promo.checkValidity(
        subtotal: subtotal,
        currentRestaurantId: restaurantId,
      );
      if (!valid) {
        return CouponValidationResult(
          isValid: false,
          message: reason ?? 'Coupon is not applicable.',
        );
      }

      // 2. Check per-user redemption limit
      if (userId.isNotEmpty && promo.perUserLimit > 0) {
        try {
          final redemptions = await supabaseClient
              .from('promotion_redemptions')
              .select('id')
              .eq('promotion_id', promo.id)
              .eq('user_id', userId);

          final count = (redemptions as List).length;
          if (count >= promo.perUserLimit) {
            return const CouponValidationResult(
              isValid: false,
              message: 'You have already reached the redemption limit for this coupon.',
            );
          }
        } catch (e) {
          debugPrint('Error checking user redemption limit: $e');
          // Proceed gracefully if check fails
        }
      }

      // 3. Compute discount amount
      final discount = promo.calculateDiscount(
        subtotal: subtotal,
        deliveryFee: deliveryFee,
      );

      if (discount <= 0.0) {
        return const CouponValidationResult(
          isValid: false,
          message: 'Order does not meet criteria for this discount.',
        );
      }

      return CouponValidationResult(
        isValid: true,
        message: 'Coupon "${promo.code}" applied! You saved Rs ${discount.toStringAsFixed(0)}.',
        promotion: promo,
        discountAmount: discount,
      );
    } catch (e) {
      debugPrint('Error validating coupon: $e');
      return CouponValidationResult(
        isValid: false,
        message: 'Failed to validate coupon: $e',
      );
    }
  }

  /// Records a successful redemption and increments the used count.
  Future<void> recordPromotionRedemption({
    required int promotionId,
    required String userId,
    required int? orderId,
    required double amount,
  }) async {
    try {
      await supabaseClient.from('promotion_redemptions').insert({
        'promotion_id': promotionId,
        'user_id': userId,
        'order_id': orderId,
        'amount': amount,
      });

      // Update used_count
      try {
        final current = await supabaseClient
            .from('promotions')
            .select('used_count')
            .eq('id', promotionId)
            .maybeSingle();

        final currentCount = current?['used_count'] is int ? current!['used_count'] as int : 0;
        await supabaseClient
            .from('promotions')
            .update({'used_count': currentCount + 1})
            .eq('id', promotionId);
      } catch (e) {
        debugPrint('Could not update used_count: $e');
      }
    } catch (e) {
      debugPrint('Error recording promotion redemption: $e');
    }
  }

  /// Fetches active sponsored banner ads and promotional banners for the Home carousel.
  Future<List<HomeBannerItem>> fetchActiveHomeBanners() async {
    final List<HomeBannerItem> banners = [];
    try {
      // 1. Fetch approved / active banner_slots
      final slotsResponse = await supabaseClient
          .from('banner_slots')
          .select()
          .inFilter('status', ['approved', 'active', 'live'])
          .not('banner_image_url', 'is', null);

      for (final row in slotsResponse) {
        final slot = BannerSlotModel.fromJson(row);
        if (slot.bannerImageUrl != null && slot.bannerImageUrl!.isNotEmpty) {
          banners.add(HomeBannerItem.fromBannerSlot(slot));
        }
      }
    } catch (e) {
      debugPrint('Error loading banner_slots: $e');
    }

    try {
      // 2. Also fetch active promotions that have banner_image uploaded
      final promoResponse = await supabaseClient
          .from('promotions')
          .select()
          .eq('is_active', true)
          .not('banner_image', 'is', null);

      for (final row in promoResponse) {
        final promo = PromotionModel.fromJson(row);
        if (promo.bannerImage != null && promo.bannerImage!.isNotEmpty) {
          banners.add(
            HomeBannerItem(
              id: 'promo_${promo.id}',
              imageUrl: promo.bannerImage!,
              isNetwork: true,
              title: promo.title,
              restaurantId: promo.restaurantId,
              promoCode: promo.code,
              discountTag: promo.badgeLabel,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading promotion banners: $e');
    }

    return banners;
  }
}
