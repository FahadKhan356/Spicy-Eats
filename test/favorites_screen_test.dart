import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spicy_eats/features/Favorites/data/FavoritesStore.dart';
import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';
import 'package:spicy_eats/features/Favorites/repository/FavoritesRepository.dart';
import 'package:spicy_eats/features/Favorites/Screens/FavoriteScrren.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

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
}
