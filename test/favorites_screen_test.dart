import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spicy_eats/features/Favorites/data/FavoritesStore.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';
import 'package:spicy_eats/features/Favorites/repository/FavoritesRepository.dart';
import 'package:spicy_eats/features/Favorites/Screens/FavoriteScrren.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';

class _FakeFavoritesStore implements FavoritesStore {
  _FakeFavoritesStore([List<FavoriteDish>? seed])
      : _rows = [...?seed];

  final List<FavoriteDish> _rows;
  int _nextId = 1;

  @override
  Future<List<FavoriteDish>> getFavorites(String userId) async =>
      _rows.where((row) => row.userId == userId).toList();

  @override
  Future<int> addFavorite(FavoriteDish favorite) async {
    _rows.removeWhere(
        (row) => row.userId == favorite.userId && row.dishId == favorite.dishId);
    _rows.add(favorite);
    return _nextId++;
  }

  @override
  Future<void> removeFavorite(String userId, int dishId) async {
    _rows.removeWhere((row) => row.userId == userId && row.dishId == dishId);
  }

  @override
  Future<int> clearFavorites(String userId) async {
    final before = _rows.length;
    _rows.removeWhere((row) => row.userId == userId);
    return before - _rows.length;
  }
}

FavoriteDish _favorite(int id, {bool isVariation = false}) => FavoriteDish(
      userId: 'guest_user',
      dishId: id,
      name: 'Cheese Burger $id',
      description: 'A fresh cheese burger',
      image: 'https://example.com/burger$id.jpg',
      price: 20,
      discountPrice: 15,
      restaurantId: 'rest1',
      restaurantName: 'Burger King',
      isVariation: isVariation,
      isVeg: true,
      createdAt: DateTime.now().toIso8601String(),
    );

DishData _dish(int id) => DishData(
      dishid: id,
      dish_name: 'Cheese Burger $id',
      dish_description: 'A fresh cheese burger',
      dish_imageurl: 'https://example.com/burger$id.jpg',
      dish_price: 20,
      isVariation: false,
    );

RestaurantModel _restaurant() => RestaurantModel(
      restuid: 'rest1',
      restaurantName: 'Burger King',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // GoTrue keeps its session in shared_preferences; without the mock the
    // plugin channel is missing and Supabase.initialize throws.
    SharedPreferences.setMockInitialValues({});
    // Dummy project: favorites only read auth.currentUser, which stays null
    // here, so the notifier falls back to its guest user id.
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
  });

  testWidgets('shows empty state when nothing is hearted', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteDishListProvider
              .overrideWith((ref) => FavoriteDishNotifier(_FakeFavoritesStore())),
        ],
        child: const MaterialApp(home: Favoritescreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('No Favorites Yet'), findsOneWidget);
    expect(find.text('Explore Menu'), findsOneWidget);
  });

  testWidgets('lists saved dishes with image, price and cart action',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteDishListProvider.overrideWith(
            (ref) => FavoriteDishNotifier(
                _FakeFavoritesStore([_favorite(1), _favorite(2, isVariation: true)])),
          ),
        ],
        child: const MaterialApp(home: Favoritescreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 items saved'), findsOneWidget);
    expect(find.text('Cheese Burger 1'), findsOneWidget);
    expect(find.text('Cheese Burger 2'), findsOneWidget);
    expect(find.text('Burger King'), findsNWidgets(2));
    // One network image per favorite.
    expect(find.byType(Image), findsNWidgets(2));
    // Discounted price is what gets charged, original is struck through.
    expect(find.text('\$15.00'), findsNWidgets(2));
    expect(find.text('\$20.00'), findsNWidgets(2));
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text('Options'), findsNWidgets(2));
  });

  testWidgets('remove asks for confirmation then drops the dish',
      (tester) async {
    final store = _FakeFavoritesStore([_favorite(1), _favorite(2)]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          favoriteDishListProvider
              .overrideWith((ref) => FavoriteDishNotifier(store)),
        ],
        child: const MaterialApp(home: Favoritescreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite).first);
    await tester.pumpAndSettle();

    expect(find.text('Remove from Favorites'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Cheese Burger 1'), findsNothing);
    expect(find.text('Cheese Burger 2'), findsOneWidget);
    expect(store._rows.length, 1);
  });

  test('notifier toggles a dish on and back off', () async {
    final store = _FakeFavoritesStore();
    final notifier = FavoriteDishNotifier(store);

    final added = await notifier.toggle(
      dish: _dish(7),
      restaurantId: 'rest1',
      restaurantName: 'Burger King',
    );
    expect(added, isTrue);
    expect(notifier.isFavorite(7), isTrue);
    expect(notifier.state.single.name, 'Cheese Burger 7');

    final removed = await notifier.toggle(
      dish: _dish(7),
      restaurantId: 'rest1',
      restaurantName: 'Burger King',
    );
    expect(removed, isFalse);
    expect(notifier.isFavorite(7), isFalse);
    expect(notifier.state, isEmpty);
  });

  test('notifier restores a removed favorite on undo', () async {
    final notifier = FavoriteDishNotifier(_FakeFavoritesStore([_favorite(3)]));
    await notifier.load(userId: 'guest_user');

    await notifier.remove(3);
    expect(notifier.state, isEmpty);

    await notifier.restore(_favorite(3));
    expect(notifier.isFavorite(3), isTrue);
  });

  test('notifier clears every favorite for the user', () async {
    final notifier =
        FavoriteDishNotifier(_FakeFavoritesStore([_favorite(1), _favorite(2)]));
    await notifier.load(userId: 'guest_user');
    expect(notifier.state, hasLength(2));

    expect(await notifier.clearAll(), 2);
    expect(notifier.state, isEmpty);
  });

  test('favorite round-trips through its database map', () {
    final original = _favorite(9, isVariation: true);
    final restored = FavoriteDish.fromMap(original.toMap());

    expect(restored.dishId, original.dishId);
    expect(restored.name, original.name);
    expect(restored.image, original.image);
    expect(restored.price, original.price);
    expect(restored.discountPrice, original.discountPrice);
    expect(restored.isVariation, isTrue);
    expect(restored.isVeg, isTrue);
    expect(restored.payablePrice, 15);
    expect(restored.discountPercent, 25);
  });

  // Tapping "Options" on a favorited variation dish opens the variation screen
  // with no matching cart row, because the dish was hearted rather than added.
  // The screen used to dereference that missing cartDish while building and
  // died with "Null check operator used on a null value".
  testWidgets('variation screen opens a favorited dish that is not in the cart',
      (tester) async {
    final dish = _dish(1);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DishMenuVariation(
            dish: DishData(
              dishid: dish.dishid,
              dish_name: dish.dish_name,
              dish_description: dish.dish_description,
              dish_imageurl: dish.dish_imageurl,
              dish_price: dish.dish_price,
              isVariation: true,
            ),
            isCart: false,
            cartDish: null,
            carts: const [],
            isdishscreen: true,
            restaurantData: _restaurant(),
            dishes: [dish],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  // Favorites is the second tab of the Home shell. "Explore" used to push a
  // brand new HomeScreen route, which left the user on a bare screen with a
  // back button and no bottom nav. It has to hand control back to the shell
  // and ask it for its first tab instead.
  testWidgets('explore returns to the Home shell instead of stacking a route',
      (tester) async {
    int? observedIndex;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => settings.name == Favoritescreen.routename
                ? const Favoritescreen()
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
    Navigator.of(shellContext).pushNamed(Favoritescreen.routename);
    await tester.pumpAndSettle();
    expect(find.text('No Favorites Yet'), findsOneWidget);

    await tester.tap(find.text('Explore Menu'));
    await tester.pumpAndSettle();

    // Back on the shell, which is now asked to show its first tab. A stacked
    // HomeScreen route would have left this text absent.
    expect(find.text('shell-home'), findsOneWidget);
    expect(find.text('No Favorites Yet'), findsNothing);
    expect(observedIndex, 0);
  });
}
