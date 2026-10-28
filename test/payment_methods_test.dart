import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spicy_eats/features/Payment/model/payment_method_model.dart';
import 'package:spicy_eats/features/Payment/repo/payment_methods_repository.dart';
import 'package:spicy_eats/features/Payment/screens/manage_payment_methods_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockPaymentMethodsRepository extends PaymentMethodsRepository {
  final List<PaymentMethodModel> mockList;

  MockPaymentMethodsRepository({required this.mockList})
      : super(supabase: Supabase.instance.client);

  @override
  Future<List<PaymentMethodModel>> fetchUserPaymentMethods(String userId) async {
    return List.from(mockList);
  }

  @override
  Future<PaymentMethodModel?> addPaymentMethod(PaymentMethodModel model) async {
    final created = model.copyWith(paymentId: 'mock-uuid-999');
    mockList.insert(0, created);
    return created;
  }

  @override
  Future<bool> deletePaymentMethod(String paymentId) async {
    mockList.removeWhere((m) => m.paymentId == paymentId);
    return true;
  }

  @override
  Future<bool> setDefaultPaymentMethod({
    required String paymentId,
    required String userId,
  }) async {
    for (int i = 0; i < mockList.length; i++) {
      mockList[i] = mockList[i].copyWith(isDefault: mockList[i].paymentId == paymentId);
    }
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
  });

  group('PaymentMethodModel Unit Tests', () {
    test('detects card brand accurately from prefix', () {
      final visa = PaymentMethodModel(
        userId: 'u1',
        cardNumber: '4242424242424242',
      );
      expect(visa.brand, CardBrand.visa);
      expect(visa.brandName, 'Visa');

      final mastercard = PaymentMethodModel(
        userId: 'u1',
        cardNumber: '5500000000000004',
      );
      expect(mastercard.brand, CardBrand.mastercard);
      expect(mastercard.brandName, 'Mastercard');

      final amex = PaymentMethodModel(
        userId: 'u1',
        cardNumber: '378282246310005',
      );
      expect(amex.brand, CardBrand.amex);
      expect(amex.brandName, 'American Express');
    });

    test('masks card number showing only last 4 digits', () {
      final card = PaymentMethodModel(
        userId: 'u1',
        cardNumber: '4111 2222 3333 4444',
      );
      expect(card.maskedCardNumber, '•••• •••• •••• 4444');
    });

    test('JSON serialization & deserialization works correctly with Supabase schema', () {
      final json = {
        'paymentId': 'f3b8b6a1-9c88-4682-990a-1a80d5f99234',
        'user_id': 'user-123',
        'accountHolderName': 'Alex Morgan',
        'cardHolder': 'Alex Morgan',
        'cardNumber': '4242424242424242',
        'expiryDate': '08/29',
        'MM/YY': '08/29',
        'cvv': '123',
        'paymentType': 'Card',
        'isDefault': true,
      };

      final model = PaymentMethodModel.fromJson(json);

      expect(model.paymentId, 'f3b8b6a1-9c88-4682-990a-1a80d5f99234');
      expect(model.userId, 'user-123');
      expect(model.effectiveHolderName, 'Alex Morgan');
      expect(model.effectiveExpiry, '08/29');
      expect(model.isDefault, isTrue);
      expect(model.maskedCardNumber, '•••• •••• •••• 4242');

      final exported = model.toJson();
      expect(exported['paymentId'], 'f3b8b6a1-9c88-4682-990a-1a80d5f99234');
      expect(exported['user_id'], 'user-123');
      expect(exported['cardHolder'], 'Alex Morgan');
      expect(exported['MM/YY'], '08/29');
      expect(exported['isDefault'], isTrue);
    });
  });

  group('ManagePaymentMethodsScreen Widget Tests', () {
    testWidgets('renders Cash on Delivery and empty card state when no cards saved',
        (WidgetTester tester) async {
      final mockRepo = MockPaymentMethodsRepository(mockList: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            paymentMethodsRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ManagePaymentMethodsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('No Saved Cards'), findsOneWidget);
      expect(find.text('Add New Card'), findsOneWidget);
    });

    testWidgets('renders saved card with DEFAULT badge and masked digits',
        (WidgetTester tester) async {
      final sampleCards = [
        PaymentMethodModel(
          paymentId: 'card-1',
          userId: 'test-user',
          cardHolder: 'Sarah Connor',
          cardNumber: '4242424242429876',
          expiryDate: '11/27',
          mmYy: '11/27',
          cvv: '999',
          isDefault: true,
        ),
      ];

      final mockRepo = MockPaymentMethodsRepository(mockList: sampleCards);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            paymentMethodsRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ManagePaymentMethodsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('Saved Cards (1)'), findsOneWidget);
      expect(find.text('DEFAULT'), findsOneWidget);
      expect(find.text('•••• •••• •••• 9876'), findsOneWidget);
      expect(find.text('SARAH CONNOR'), findsOneWidget);
      expect(find.text('11/27'), findsOneWidget);
    });
  });
}
