import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Lists.dart';
import 'package:spicy_eats/features/promotions/models/banner_slot_model.dart';
import 'package:spicy_eats/features/promotions/models/promotion_model.dart';
import 'package:spicy_eats/features/promotions/repository/promotion_repository.dart';

final promotionRepoProvider = Provider<PromotionRepository>((ref) {
  return PromotionRepository();
});

/// Currently applied coupon in Cart/Checkout.
final appliedCouponProvider = StateProvider<PromotionModel?>((ref) => null);

/// Computed discount amount for the applied coupon.
final appliedDiscountAmountProvider = StateProvider<double>((ref) => 0.0);

/// Active banners for the Home Screen Top Carousel.
/// If Supabase returns active banners, use them. Otherwise, fall back to bundled asset images.
final homeBannersProvider = FutureProvider<List<HomeBannerItem>>((ref) async {
  final repo = ref.watch(promotionRepoProvider);
  final liveBanners = await repo.fetchActiveHomeBanners();

  if (liveBanners.isNotEmpty) {
    return liveBanners;
  }

  // Graceful fallback to default asset banners if no live sponsored banners exist
  return bannerImages
      .map((assetPath) => HomeBannerItem.fromAsset(assetPath))
      .toList();
});

/// Active promotions for a given restaurant (for menu banners & badges)
final restaurantPromotionsProvider =
    FutureProvider.family<List<PromotionModel>, String>((ref, restaurantId) async {
  final repo = ref.watch(promotionRepoProvider);
  return repo.fetchActivePromotions(restaurantId: restaurantId);
});

/// Controller to apply, remove, and manage coupons
class PromotionsController {
  final Ref _ref;

  PromotionsController(this._ref);

  Future<CouponValidationResult> applyCoupon({
    required String code,
    required double subtotal,
    String? restaurantId,
    required String userId,
    double deliveryFee = 0.0,
  }) async {
    final repo = _ref.read(promotionRepoProvider);
    final result = await repo.validateCoupon(
      code: code,
      subtotal: subtotal,
      restaurantId: restaurantId,
      userId: userId,
      deliveryFee: deliveryFee,
    );

    if (result.isValid && result.promotion != null) {
      _ref.read(appliedCouponProvider.notifier).state = result.promotion;
      _ref.read(appliedDiscountAmountProvider.notifier).state = result.discountAmount;
    }
    return result;
  }

  void removeCoupon() {
    _ref.read(appliedCouponProvider.notifier).state = null;
    _ref.read(appliedDiscountAmountProvider.notifier).state = 0.0;
  }

  Future<void> recordRedemption({
    required String userId,
    required int? orderId,
  }) async {
    final coupon = _ref.read(appliedCouponProvider);
    final discount = _ref.read(appliedDiscountAmountProvider);
    if (coupon != null && discount > 0) {
      final repo = _ref.read(promotionRepoProvider);
      await repo.recordPromotionRedemption(
        promotionId: coupon.id,
        userId: userId,
        orderId: orderId,
        amount: discount,
      );
      // Clear applied coupon after order is placed
      removeCoupon();
    }
  }
}

final promotionsControllerProvider = Provider<PromotionsController>((ref) {
  return PromotionsController(ref);
});
