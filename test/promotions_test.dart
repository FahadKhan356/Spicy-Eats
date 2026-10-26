import 'package:flutter_test/flutter_test.dart';
import 'package:spicy_eats/features/promotions/models/banner_slot_model.dart';
import 'package:spicy_eats/features/promotions/models/promotion_model.dart';
import 'package:spicy_eats/features/promotions/repository/promotion_repository.dart';

void main() {
  group('PromotionModel tests', () {
    test('calculates percent discount correctly with maxDiscount cap', () {
      final promo = PromotionModel(
        id: 1,
        title: '20% OFF',
        kind: 'percent',
        value: 20,
        minOrder: 500,
        maxDiscount: 200,
        code: 'SPICY20',
      );

      // Order under min_order
      expect(promo.calculateDiscount(subtotal: 400), 0.0);

      // Order with 20% of 800 = 160 (under maxDiscount 200)
      expect(promo.calculateDiscount(subtotal: 800), 160.0);

      // Order with 20% of 2000 = 400 (capped at maxDiscount 200)
      expect(promo.calculateDiscount(subtotal: 2000), 200.0);
    });

    test('calculates fixed discount correctly', () {
      final promo = PromotionModel(
        id: 2,
        title: 'Rs 150 OFF',
        kind: 'fixed',
        value: 150,
        minOrder: 300,
        code: 'FLAT150',
      );

      expect(promo.calculateDiscount(subtotal: 200), 0.0);
      expect(promo.calculateDiscount(subtotal: 500), 150.0);
      // Fixed discount capped at subtotal
      expect(promo.calculateDiscount(subtotal: 100), 0.0);
    });

    test('calculates free delivery discount', () {
      final promo = PromotionModel(
        id: 3,
        title: 'Free Delivery',
        kind: 'free_delivery',
        value: 0,
        minOrder: 200,
        code: 'FREESHIP',
      );

      expect(promo.calculateDiscount(subtotal: 300, deliveryFee: 50), 50.0);
      expect(promo.calculateDiscount(subtotal: 150, deliveryFee: 50), 0.0);
    });

    test('checks validity accurately against dates, minOrder, and restaurant', () {
      final promo = PromotionModel(
        id: 4,
        title: 'Weekend Special',
        kind: 'percent',
        value: 15,
        minOrder: 400,
        restaurantId: 'rest_123',
        startsAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(days: 1)),
      );

      // Subtotal too low
      final (validMin, reasonMin) = promo.checkValidity(subtotal: 300, currentRestaurantId: 'rest_123');
      expect(validMin, false);
      expect(reasonMin, contains('Minimum order'));

      // Wrong restaurant
      final (validRest, reasonRest) = promo.checkValidity(subtotal: 500, currentRestaurantId: 'other_rest');
      expect(validRest, false);
      expect(reasonRest, contains('specific participating restaurants'));

      // Valid case
      final (validOk, reasonOk) = promo.checkValidity(subtotal: 500, currentRestaurantId: 'rest_123');
      expect(validOk, true);
      expect(reasonOk, isNull);
    });

    test('generates badge labels as expected', () {
      final p1 = PromotionModel(id: 1, title: 'Title', kind: 'percent', value: 25);
      expect(p1.badgeLabel, '25% OFF');

      final p2 = PromotionModel(id: 2, title: 'Title', kind: 'fixed', value: 100);
      expect(p2.badgeLabel, 'Rs 100 OFF');

      final p3 = PromotionModel(id: 3, title: 'Title', kind: 'free_delivery', value: 0);
      expect(p3.badgeLabel, 'Free Delivery');
    });

    test('serializes and deserializes from JSON', () {
      final json = {
        'id': 10,
        'title': 'Test Promo',
        'kind': 'percent',
        'value': 10.0,
        'min_order': 200.0,
        'code': 'TEST10',
        'is_active': true,
      };

      final model = PromotionModel.fromJson(json);
      expect(model.id, 10);
      expect(model.code, 'TEST10');
      expect(model.value, 10.0);
      expect(model.isActive, true);
    });
  });

  group('Banner models tests', () {
    test('parses BannerSlotModel and maps to HomeBannerItem', () {
      final json = {
        'id': 'slot-123',
        'banner_image_url': 'https://example.com/banner.jpg',
        'banner_title': 'Hot Deals at StreetGrill',
        'restaurant_id': 'rest_001',
        'status': 'approved',
      };

      final slot = BannerSlotModel.fromJson(json);
      expect(slot.id, 'slot-123');
      expect(slot.bannerTitle, 'Hot Deals at StreetGrill');

      final item = HomeBannerItem.fromBannerSlot(slot);
      expect(item.id, 'slot-123');
      expect(item.imageUrl, 'https://example.com/banner.jpg');
      expect(item.isNetwork, true);
      expect(item.restaurantId, 'rest_001');
    });

    test('creates fallback asset HomeBannerItem', () {
      final item = HomeBannerItem.fromAsset('lib/assets/images/banners/banner1.png');
      expect(item.isNetwork, false);
      expect(item.imageUrl, 'lib/assets/images/banners/banner1.png');
      expect(item.restaurantId, isNull);
    });

    test('CouponValidationResult holds values correctly', () {
      const result = CouponValidationResult(
        isValid: true,
        message: 'Success',
        discountAmount: 120.0,
      );
      expect(result.isValid, true);
      expect(result.discountAmount, 120.0);
    });
  });
}
