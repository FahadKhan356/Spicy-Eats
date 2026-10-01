import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

Cartmodel _cartItem({
  int id = 1,
  required String name,
  String restaurantId = 'rest1',
  String restaurantName = 'Burger King',
  double tprice = 40,
  List<Variation>? variations,
}) {
  return Cartmodel(
    cart_id: id,
    dish_id: id,
    name: name,
    description: 'A fresh cheese burger',
    image: 'https://example.com/burger$id.jpg',
    itemprice: 20,
    tprice: tprice,
    quantity: 2,
    user_id: 'guest_user',
    created_at: DateTime.now().toIso8601String(),
    restaurant_id: restaurantId,
    restaurant_name: restaurantName,
    variation: variations,
  );
}

Variation _variation(String name, double price) => Variation(
      id: 1,
      selected: true,
      totalvariation: price,
      variationName: name,
      variationPrice: price,
      variation_id: 1,
    );

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

  testWidgets('cart screen opens with no route arguments and no cart',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CartScreen())),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Your basket is empty'), findsOneWidget);
  });

  // The cart is a tab of the Home shell, so the bottom nav is the way out. The
  // back arrow had no valid target, and on the empty cart "Browse Menu" popped
  // the whole shell and left a black screen.
  testWidgets('cart screen has no back button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CartScreen())),
    );
    await tester.pump();

    expect(find.text('Your Basket'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('browse menu hands the shell back its first tab', (tester) async {
    var observedIndex = -1;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => settings.name == CartScreen.routename
                ? const CartScreen()
                : const Scaffold(body: Text('shell-home')),
          ),
          home: Consumer(
            builder: (context, ref, _) {
              observedIndex = ref.watch(currentIndexProvider);
              return const Scaffold(body: Text('shell-home'));
            },
          ),
        ),
      ),
    );

    final shellContext = tester.element(find.text('shell-home'));
    Navigator.of(shellContext).pushNamed(CartScreen.routename);
    await tester.pumpAndSettle();
    expect(find.text('Your basket is empty'), findsOneWidget);

    await tester.tap(find.text('Browse Menu'));
    await tester.pumpAndSettle();

    // Still alive, and asking the shell for its first tab.
    expect(find.text('shell-home'), findsOneWidget);
    expect(observedIndex, 0);
  });

  // The screen used to require a menu list and a restaurant from route
  // arguments, and fell back to a blank DishData for any item it could not
  // find in that list - so the rows rendered empty. It now rebuilds the dish
  // from the cart row itself.
  testWidgets('cart screen lists real rows straight from the cart',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith((ref) => [
                _cartItem(id: 1, name: 'Cheese Burger'),
                _cartItem(
                  id: 2,
                  name: 'Fries',
                  restaurantId: 'rest2',
                  restaurantName: 'Pizza Hut',
                ),
              ]),
        ],
        child: const MaterialApp(home: CartScreen()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    // Header counts both rows and both restaurants.
    expect(find.text('2 items from 2 restaurants'), findsOneWidget);
    // Item names come from the cart row, not from a menu lookup.
    expect(find.text('Cheese Burger'), findsOneWidget);
    expect(find.text('Fries'), findsOneWidget);
    // Grouped per restaurant.
    expect(find.text('Burger King'), findsOneWidget);
    expect(find.text('Pizza Hut'), findsOneWidget);
    // Quantity from the cart row.
    expect(find.text('2'), findsNWidgets(2));
    // Line total is the row's tprice.
    expect(find.text('\$40.00'), findsNWidgets(2));
  });

  testWidgets('cart screen totals variations on top of the line prices',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith((ref) => [
                _cartItem(
                  id: 1,
                  name: 'Burger',
                  tprice: 40,
                  variations: [_variation('Extra cheese', 5)],
                ),
              ]),
        ],
        child: const MaterialApp(home: CartScreen()),
      ),
    );
    await tester.pump();

    // 40.00 line price + 5.00 variation = 45.00
    expect(find.text('\$45.00'), findsWidgets);
  });

  test('getTotalPrice survives rows with a null tprice', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(cartProvider.notifier).state = [
      Cartmodel(
        cart_id: 1,
        dish_id: 1,
        name: 'No total',
        quantity: 1,
        tprice: null,
        created_at: DateTime.now().toIso8601String(),
      ),
      _cartItem(id: 2, name: 'Priced', tprice: 12),
    ];

    // A null tprice used to throw "Null check operator used on a null value".
    expect(container.read(cartProvider).length, 2);
  });
}
