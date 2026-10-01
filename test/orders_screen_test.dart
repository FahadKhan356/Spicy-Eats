import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spicy_eats/features/orders/model/orderModel.dart';
import 'package:spicy_eats/features/orders/repository/OrderListRepository.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';

class _FakeOrderStore implements OrderStore {
  _FakeOrderStore({this.orders = const [], this.shouldThrow = false});

  final List<CustomerOrder> orders;
  final bool shouldThrow;
  String? askedForUserId;
  int calls = 0;

  @override
  Future<List<CustomerOrder>> fetchOrders({required String userId}) async {
    askedForUserId = userId;
    calls++;
    if (shouldThrow) throw Exception('network down');
    return orders;
  }
}

/// A notifier already holding [orders]. The screen's own load() cannot run in
/// tests because there is no auth session, so the state is seeded instead.
OrderListNotifier _seeded(List<CustomerOrder> orders) {
  final notifier = OrderListNotifier(_FakeOrderStore());
  notifier.state = OrdersState(orders: orders);
  return notifier;
}

/// A row shaped exactly like the real `orders` table, including the
/// `variation` column being a JSON *string* rather than a list.
Map<String, dynamic> _row({
  int id = 7,
  String status = 'completed',
  double total = 66,
  String restaurant = 'Al Baiq - Official Branch',
}) {
  return {
    'id': id,
    'created_at': '2025-08-29T22:01:30.090568+00:00',
    'ordersId': null,
    'orderedFrom': restaurant,
    'deliveredTo': 'Ali Khan',
    'orderedItems': [
      {
        'id': 1,
        'name': 'Double Baik (Deal 50-50)',
        'image': 'https://example.com/baik.jpg',
        'tprice': 6.0,
        'dish_id': 11,
        'quantity': 3,
        'itemprice': 6.0,
        'variation':
            '[{"id":5,"variation_name":"Garlic Aioli","variation_price":0.0},'
            '{"id":1,"variation_name":"Brioche Bun","variation_price":1.0}]',
        'description': 'Two juicy chicken fillets.',
        'frequently_boughtList': '[]',
      },
    ],
    'payType': 'Cash on Delivery',
    'total_price': total,
    'status': status,
    'user_id': null,
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // GoTrue keeps its session in shared_preferences; without the mock the
    // plugin channel is missing and Supabase.initialize throws.
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
  });

  group('order parsing', () {
    test('reads a real orders row including its string-encoded variations', () {
      final order = CustomerOrder.fromJson(_row());

      expect(order.id, 7);
      expect(order.restaurantName, 'Al Baiq - Official Branch');
      expect(order.deliveredTo, 'Ali Khan');
      expect(order.payType, 'Cash on Delivery');
      expect(order.status, OrderStatus.completed);
      expect(order.totalPrice, 66);
      expect(order.createdAt.toUtc().year, 2025);

      expect(order.items, hasLength(1));
      final item = order.items.first;
      expect(item.name, 'Double Baik (Deal 50-50)');
      expect(item.quantity, 3);
      expect(item.dishId, 11);
      expect(item.variations, hasLength(2));
      expect(item.variations.first.name, 'Garlic Aioli');
      expect(item.variations.last.price, 1.0);
      expect(item.variations.last.label, 'Brioche Bun +\$1.00');
      expect(order.itemCount, 3);
      expect(order.itemCountLabel, '3 items');
    });

    test('status parsing is case insensitive and never throws', () {
      expect(OrderStatus.parse('Pending'), OrderStatus.pending);
      expect(OrderStatus.parse('delivered'), OrderStatus.delivered);
      expect(OrderStatus.parse('COMPLETED'), OrderStatus.completed);
      expect(OrderStatus.parse('cancelled'), OrderStatus.cancelled);
      // Rows written before the status column was filled in.
      expect(OrderStatus.parse(null), OrderStatus.unknown);
      expect(OrderStatus.parse('something-new'), OrderStatus.unknown);
      expect(OrderStatus.unknown.label, 'Processing');
    });

    test('survives a malformed orderedItems and variation payload', () {
      final order = CustomerOrder.fromJson({
        'id': 1,
        'created_at': '2025-01-01T00:00:00Z',
        'orderedFrom': 'Somewhere',
        'orderedItems': 'not-a-list',
        'status': 'pending',
      });
      expect(order.items, isEmpty);
      expect(order.itemsSummary, 'No items');
      expect(order.canReorder, isFalse);
    });

    test('falls back to summing the lines when total_price is missing', () {
      final row = _row(total: 0);
      final order = CustomerOrder.fromJson(row);
      // No stored total, so 6.00 unit x 3. The stored tprice of 6.00 is the
      // unit price on this legacy row, not a line total.
      expect(order.payableTotal, 18);
    });

    test('malformed variation json degrades to an empty list', () {
      expect(OrderedVariation.parseAll('not json'), isEmpty);
      expect(OrderedVariation.parseAll(''), isEmpty);
      expect(OrderedVariation.parseAll(null), isEmpty);
      expect(OrderedVariation.parseAll('[{"variation_name":"X"}]'), hasLength(1));
    });
  });

  group('order notifier', () {
    test('loads the signed in user orders', () async {
      final store =
          _FakeOrderStore(orders: [CustomerOrder.fromJson(_row())]);
      final notifier = OrderListNotifier(store);

      await notifier.load(userId: 'user-1');

      expect(store.askedForUserId, 'user-1');
      expect(notifier.state.orders, hasLength(1));
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.hasLoaded, isTrue);
    });

    test('does not query the store when nobody is signed in', () async {
      final store = _FakeOrderStore();
      final notifier = OrderListNotifier(store)..state =
          OrdersState(orders: [CustomerOrder.fromJson(_row())], isLoading: true);

      // No session in tests, so there is nobody to load orders for. The list
      // already on screen must survive that.
      await notifier.load();

      expect(store.calls, 0);
      expect(notifier.state.orders, hasLength(1));
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
    });

    test('an error surfaces as a retryable message, not a crash', () async {
      final notifier =
          OrderListNotifier(_FakeOrderStore(shouldThrow: true));

      await notifier.load(userId: 'user-1');

      expect(notifier.state.error, isNotNull);
      expect(notifier.state.orders, isEmpty);
      expect(notifier.state.isLoading, isFalse);
    });

    test('a second visit reuses the load, force re-reads', () async {
      final store =
          _FakeOrderStore(orders: [CustomerOrder.fromJson(_row())]);
      final notifier = OrderListNotifier(store);

      await notifier.load(userId: 'user-1');
      await notifier.load(userId: 'user-1');
      expect(store.calls, 1);

      await notifier.load(userId: 'user-1', force: true);
      expect(store.calls, 2);
    });
  });

  testWidgets('orders screen shows a real empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider
              .overrideWith((ref) => OrderListNotifier(_FakeOrderStore())),
        ],
        child: const MaterialApp(home: OrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Your Orders'), findsOneWidget);
    expect(find.text('No Orders Yet'), findsOneWidget);
    expect(find.text('Your placed orders will show up here.'), findsOneWidget);
  });

  // The card used to render hardcoded strings - always "Delivered", a fixed
  // date, a fixed restaurant, a fixed amount - whatever the data said.
  testWidgets('orders screen renders the real row values', (tester) async {
    final order = CustomerOrder.fromJson(_row());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider
              .overrideWith((ref) => _seeded([order])),
        ],
        child: const MaterialApp(home: OrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // Real status, not a hardcoded "Delivered".
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Delivered'), findsNothing);
    // Real restaurant, payment method and amount.
    expect(find.text('Al Baiq - Official Branch'), findsOneWidget);
    expect(find.text('Cash on Delivery'), findsWidgets);
    expect(find.text('\$66.00'), findsOneWidget);
    // Real item summary and count.
    expect(find.text('3x Double Baik (Deal 50-50)'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);
    // Real date, formatted from created_at.
    expect(find.textContaining('2025'), findsNothing);
    expect(find.textContaining('Aug'), findsOneWidget);
    // The dish image comes from the order, not a hardcoded URL.
    expect(find.byType(Image), findsOneWidget);
    // Actions are live.
    expect(find.text('Reorder'), findsOneWidget);
  });

  testWidgets('cancelled orders render their own status colour',
      (tester) async {
    final order = CustomerOrder.fromJson(_row(status: 'cancelled'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider
              .overrideWith((ref) => _seeded([order])),
        ],
        child: const MaterialApp(home: OrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('view details lists the real lines of the order', (tester) async {
    final order = CustomerOrder.fromJson(_row());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider
              .overrideWith((ref) => _seeded([order])),
        ],
        child: const MaterialApp(home: OrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('3x Double Baik (Deal 50-50)'), findsWidgets);
    expect(find.text('Garlic Aioli'), findsOneWidget);
    expect(find.text('Brioche Bun +\$1.00'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Paid with Cash on Delivery'), findsOneWidget);
  });
}
