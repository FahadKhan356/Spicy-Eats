import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ScaffoldMessenger, SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';

import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Sqlight%20Database/CartLocalDatabase.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

var cartProvider = StateProvider<List<Cartmodel>>((ref) => []);
var cartPriceSumProvider = StateProvider<double>((ref) => 0);
var cartReopProvider =
    Provider((ref) => CartRepository(CartLocalDatabase.instance));

//debouncer class to prevent race condition
class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  // VoidCallback? action;
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(microseconds: milliseconds), action);
  }
}

//Mutex class to prevent race condition
class Mutex {
  bool _isLocked = false;

  Future<void> run(Function action) async {
    if (_isLocked) return;
    _isLocked = true;
    try {
      await action();
    } finally {
      _isLocked = false;
    }
  }
}

class CartRepository {
  final CartLocalDatabase _database;

  CartRepository(this._database);

  final _mutex = Mutex();

//Fetch Cart From Sqlight
  Future<void> initializeCart(
      {required String userId, required WidgetRef ref}) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);

      final data = await _database.getCartItems(userId);
      if (data.isEmpty) {
        cartNotifier.state = [];
      } else {
        cartNotifier.state = data;
      }
    } catch (e, stackTrace) {
      debugPrint('Failed To Fetch Cart Data $e');
      debugPrint('Stack Trace $stackTrace');
    }
  }

//Update CartItem Locally For Sqlight
  Future<void> updateCartItems({
    required int dishId,
    required WidgetRef ref,
    required double price,
    required int newQuantity,
    required List<Variation> newVariations,
  }) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final priceNotifier = ref.read(cartPriceSumProvider.notifier);

      final currentCart = cartNotifier.state;
      final index = currentCart.indexWhere((item) => item.dish_id == dishId);

      if (index == -1) return;

      final updatedItem = currentCart[index].copyWith(
        variation: newVariations,
        quantity: newQuantity,
        tprice: price * newQuantity,
        created_at: DateTime.now().toIso8601String(),
      );
      // 4. Update in SQLite FIRST
      await _database.updateCartItem(updatedItem);

      final newCart = [
        ...currentCart.sublist(0, index),
        updatedItem,
        ...currentCart.sublist(index + 1),
      ];

      cartNotifier.state = newCart;
      priceNotifier.state =
          newCart.fold(0, (sum, item) => sum + item.tprice!.toDouble());
    } catch (e) {
      debugPrint("Failed to Update $e");
    }
  }

//Add CartItem Locally For Sqlight
  Future<void> addCartItem({
    required double itemprice,
    required name,
    required description,
    required WidgetRef ref,
    required String userId,
    required int dishId,
    required double? discountprice,
    required double? price,
    required String image,
    required List<Variation>? variations,
    required bool isdishScreen,
    required int quantity,
    required List<DishData>? freqboughts,
  }) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final priceNotifier = ref.read(cartPriceSumProvider.notifier);

      final currentCart = cartNotifier.state;
      final index = currentCart.indexWhere((item) => item.dish_id == dishId);

      if (index != -1) {
        final newQuantity = quantity += currentCart[index].quantity;
        final updatedCart = currentCart[index].copyWith(
            quantity: newQuantity,
            variation: variations,
            tprice: discountprice != null
                ? discountprice * newQuantity
                : price! * newQuantity,
            created_at: currentCart[index].created_at);

        await _database.updateCartItem(updatedCart);
        final newCart = [
          ...currentCart.sublist(0, index),
          updatedCart,
          ...currentCart.sublist(index + 1),
        ];
        cartNotifier.state = newCart;
        priceNotifier.state =
            newCart.fold(0, (sum, item) => sum + (item.tprice!.toDouble()));
      } else {
        final newItem = Cartmodel(
            tprice: price,
            description: description,
            user_id: userId,
            dish_id: dishId,
            itemprice: price,
            image: image,
            freqboughts: freqboughts ?? [],
            variation: variations ?? [],
            created_at: DateTime.now().toIso8601String(),
            name: name,
            quantity: quantity);

        final newId = await _database.insertCartItem(newItem);
        if (newId <= 0) {
          throw Exception('Failed to insert cart');
        }

        final updatedItem = newItem.copyWith(
          cart_id: newId,
        );

        cartNotifier.state = [...currentCart, updatedItem];
        priceNotifier.state =
            cartNotifier.state.fold(0, (sum, item) => sum + (item.tprice ?? 0));

        debugPrint(
            "Updated cart created at ${updatedItem.created_at} ${updatedItem.name}");
      }
    } catch (e) {
      debugPrint("Failed To Add  In Cart $e");
    }
  }

//Increase quantity Locally Sqlight
  Future<void> incQuantity(
      {required WidgetRef ref,
      required int dishId,
      required double price}) async {
    final cartNotifier = ref.read(cartProvider.notifier);
    final priceNotifier = ref.read(cartPriceSumProvider.notifier);

    final curentCart = cartNotifier.state;
    final index = curentCart.indexWhere((item) => item.dish_id == dishId);

    if (index == -1) return;

    final updatedItem = curentCart[index].copyWith(
        quantity: curentCart[index].quantity + 1,
        tprice: (curentCart[index].quantity + 1) * price);

    await _database.updateCartItem(updatedItem);

    final newCart = [
      ...curentCart.sublist(0, index),
      updatedItem,
      ...curentCart.sublist(index + 1),
    ];

    cartNotifier.state = newCart;
    priceNotifier.state =
        newCart.fold(0, (sum, item) => sum + (item.tprice ?? 0));
  }

//Increase quantity Locally Sqlight
  Future<void> decQuantity(
      {required WidgetRef ref,
      required int dishId,
      required double price}) async {
    final cartNotifier = ref.read(cartProvider.notifier);
    final priceNotifier = ref.read(cartPriceSumProvider.notifier);

    final curentCart = cartNotifier.state;
    final index = curentCart.indexWhere((item) => item.dish_id == dishId);

    if (index == -1) return;

    if (curentCart[index].quantity <= 1) {
      await _database.deleteCartItem(curentCart[index].cart_id);
      final newCart = [
        ...curentCart.sublist(0, index),
        ...curentCart.sublist(index + 1),
      ];
      cartNotifier.state = newCart;
    } else {
      final updatedItem = curentCart[index].copyWith(
          quantity: curentCart[index].quantity - 1,
          tprice: (curentCart[index].quantity - 1) * price);

      await _database.updateCartItem(updatedItem);
      final newCart = [
        ...curentCart.sublist(0, index),
        updatedItem,
        ...curentCart.sublist(index + 1),
      ];

      cartNotifier.state = newCart;
      priceNotifier.state =
          newCart.fold(0, (sum, item) => sum + (item.tprice ?? 0));
    }
  }

  double getTotalPrice(WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return cart.fold(0.0,
        (previousValue, element) => previousValue + (element.tprice ?? 0.0));
  }

  int getTotalQuantityofdish(WidgetRef ref, int dishid) {
    final cart = ref.watch(cartProvider);
    return cart.fold(
        0, (sum, item) => item.dish_id == dishid ? sum + item.quantity : sum);
  }

//Clearing Cart Locally and from State
  Future<void> clearCart(
      {required WidgetRef ref, required String userId, context}) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);

      // 1. Clear local SQLite
      final deletedCount = await _database.clearCart();
      debugPrint('Cleared $deletedCount items from local cart');

      // 2. Update UI state
      cartNotifier.state = [];
      ref.read(cartPriceSumProvider.notifier).state = 0.0;

      // 3. Immediately try syncing if online
      // unawaited(repository.syncPendingChanges());
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear cart: ${e.toString()}')));
    }
  }

//Funtion To Sync Supabase Cart Data to Sqlight Cart Table
  Future<void> syncCartFromSupabase(String userId) async {
    // 1. Fetch cart data from Supabase
    final response =
        await supabaseClient.from('cart').select().eq('user_id', userId);

    // 2. Clear existing local cart
    await _database.clearCart();

    // 3. Insert all items into SQLite
    for (final item in response) {
      await _database.insertCartItem(Cartmodel(
        cart_id: item['id'],
        dish_id: item['dish_id'],
        quantity: item['quantity'],
        tprice: item['tprice'],
        user_id: item['user_id'],
        created_at: DateTime.parse(item['created_at']).toIso8601String(),
        image: item['image'],
        itemprice: item['itemprice'],
        name: item['name'],
        description: item['description'],
        variation: item['variations'] != null
            ? (item['variations'] as List)
                .map((v) => Variation.fromjson(v))
                .toList()
            : null,
      ));
    }
  }

  Future<void> deleteCartItem({required dishId, required WidgetRef ref}) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final priceNotifier = ref.read(cartPriceSumProvider.notifier);
      final currentCart = cartNotifier.state;

      final index = currentCart.indexWhere((item) => item.dish_id == dishId);

      if (index == -1) return;
      debugPrint("Removed $dishId");
      await _database.deleteCartItem(dishId);

      final newCart = cartNotifier.state = [
        ...currentCart.sublist(0, index),
        ...currentCart.sublist(index + 1),
      ];

      cartNotifier.state = newCart;
      priceNotifier.state =
          currentCart.fold(0, (sum, item) => sum + (item.tprice!));
    } catch (e) {
      debugPrint("Failed To Delete Cart Item $e");
    }
  }
}
