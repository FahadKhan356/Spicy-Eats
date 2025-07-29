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
  //fetch cart
  // Future<void> fetchCart(WidgetRef ref, String userId) async {
  //   // final userId = supabaseClient.auth.currentUser!.id;
  //   // final cartlist = ref.read(cartProvider.notifier);

  //   if (userId.isEmpty) return;

  //   final response =
  //       await supabaseClient.from('cart').select().eq('user_id', userId);

  //   if (response.isNotEmpty) {
  //     List<Cartmodel> cartItems =
  //         response.map((json) => Cartmodel.fromjson(json)).toList();
  //     ref.read(cartProvider.notifier).state = cartItems;
  //     // cartlist.state = List.from(cartItems);

  //     print("cart fetched");
  //   }
  // }

//Fetch Cart From Sqlight
  Future<void> initializeCart(
      {required String userId, required WidgetRef ref}) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);

      final data = await _database.getCartItems(userId);
      if (data == null || data.isEmpty) {
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

// update cart

  // Future<void> updateCart(WidgetRef ref, int dishId, double price,
  //     List<Variation>? variations, quantity) async {
  //   final cart = ref.read(cartProvider.notifier);
  //   final item = cart.state;
  //   final cartTprice = ref.read(cartPriceSumProvider.notifier);

  //   final index = item.indexWhere((element) => element.dish_id == dishId);
  //   if (index != -1) {
  //     item[index].quantity = quantity;
  //     final totalprice = item[index].itemprice! * quantity;
  //     item[index].variation != variations;
  //     final response = await supabaseClient.from('cart').update({
  //       'quantity': quantity,
  //       'variations': variations != null
  //           ? variations.map((e) => e.tojson()).toList()
  //           : [],
  //       'tprice': totalprice,
  //     }).eq('id', item[index].cart_id!);

  //     if (response != null) {
  //       final items = response.map((e) => Cartmodel.fromjson(e)).toList();
  //       item.add(items);
  //     }
  //   }
  //   cart.state = List.from(item);
  //   cartTprice.state = getTotalPrice(ref);
  //   print('car total price check ${cartTprice.state}');
  // }

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

  // //addtocart
  // Future<void> addToCart(
  //   double itemprice,
  //   name,
  //   description,
  //   WidgetRef ref,
  //   String userId,
  //   int dishId,
  //   double? discountprice,
  //   double? price,
  //   String image,
  //   List<Variation>? variations,
  //   bool isdishScreen,
  //   int quantity,
  //   List<DishData>? freqboughts,
  // ) async {
  //   await _mutex.run(() async {
  //     final cart = ref.read(cartProvider.notifier);
  //     final items = cart.state;
  //     final cartTPrice = ref.read(cartPriceSumProvider.notifier);

  //     final index = items.indexWhere((item) => item.dish_id == dishId);

  //     if (index != -1 && variations == null) {
  //       //If item exists, update quantity
  //       items[index].quantity += quantity;
  //       items[index].tprice = discountprice != null
  //           ? items[index].quantity * discountprice
  //           : items[index].quantity * price!;
  //       await supabaseClient.from('cart').update({
  //         'quantity': items[index].quantity,
  //         'tprice': items[index].tprice,
  //       }).eq('id', items[index].cart_id!);
  //     } else {
  //       final itemquantity = discountprice != null
  //           ? quantity * discountprice
  //           : quantity * price!;

  //       final response = await supabaseClient.from('cart').insert({
  //         'user_id': userId,
  //         'dish_id': dishId,
  //         'quantity': quantity,
  //         'tprice': itemquantity,
  //         'image': image,
  //         'itemprice': itemprice,
  //         'name': name,
  //         'description': description,
  //         'variations': variations != null
  //             ? variations.map((v) => v.tojson()).toList()
  //             : [],
  //         'frequently_boughtList': freqboughts != null
  //             ? freqboughts.map((e) => e.tojson()).toList()
  //             : []
  //       }).select();

  //       if (response.isNotEmpty) {
  //         final newItem = Cartmodel.fromjson(response.first);
  //         items.add(newItem);
  //       }
  //     }

  //     cart.state = List.from(items); // Update state
  //     cartTPrice.state = getTotalPrice(ref);
  //     print('car total price check ${cartTPrice.state}');
  //   });
  // }

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

// //increase quantity
//   Future<void> increaseQuantity(WidgetRef ref, int dishId, double price) async {
//     await _mutex.run(() async {
//       // print('inside the increase quantity..');
//       final cart = ref.read(cartProvider.notifier);
//       final items = cart.state;
//       final cartTPrice = ref.read(cartPriceSumProvider.notifier);
//       // print('dishid given by ui: $dishId');

//       final index = ref
//           .read(cartProvider.notifier)
//           .state
//           .indexWhere((item) => item.dish_id == dishId);

//       print('dishid id in index: $index');

//       print('cart id: ${ref.read(cartProvider.notifier).state[index].cart_id}');

//       if (index != -1) {
//         print(
//             'before increase quantity:${ref.read(cartProvider.notifier).state[index].quantity}');

//         ref.read(cartProvider.notifier).state[index].quantity++;
//         final result = items[index].quantity * price.toDouble();

//         items[index].tprice = result;

//         print(
//             'after increase quantity:${ref.read(cartProvider.notifier).state[index].quantity}');

//         await supabaseClient.from('cart').update({
//           'quantity': ref.read(cartProvider.notifier).state[index].quantity,
//           'tprice': ref.read(cartProvider.notifier).state[index].tprice
//         }).eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
//       }

//       ref.read(cartProvider.notifier).state =
//           List.from(ref.read(cartProvider.notifier).state);
//       cart.state = List.from(items); // Update state
//       cartTPrice.state = getTotalPrice(ref);
//       print('ended the increase quantity..');
//       print('car total price check ${cartTPrice.state}');
//     });
//   }

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

  //deccrese quantity in basket

  // Future<void> decreaseQuantityBasket(
  //     {required int cartid, required WidgetRef ref, required price}) async {
  //   await _mutex.run(() async {
  //     final cart = ref.read(cartProvider.notifier);
  //     final items = cart.state;
  //     final index = items.indexWhere((element) => element.cart_id == cartid);
  //     final cartTPrice = ref.read(cartPriceSumProvider.notifier);

  //     if (index != -1) {
  //       if (items[index].quantity > 1) {
  //         items[index].quantity--;
  //         final result = items[index].quantity * price;
  //         items[index].tprice = result.toDouble();
  //         await supabaseClient.from('cart').update({
  //           'quantity': items[index].quantity,
  //           'tprice': items[index].quantity * price,
  //         }).eq('id', items[index].cart_id!);
  //       } else {
  //         await supabaseClient
  //             .from('cart')
  //             .delete()
  //             .eq('id', items[index].cart_id!);
  //         items.removeAt(index);
  //       }

  //       cart.state = List.from(items);
  //       cartTPrice.state = getTotalPrice(ref);
  //     }
  //   });
  // }

// //decrease qunatity
//   Future<void> decreaseQuantity(
//       WidgetRef ref, int? dishId, double price) async {
//     await _mutex.run(() async {
//       final cart = ref.read(cartProvider.notifier);
//       final items = cart.state;
//       final cartTPrice = ref.read(cartPriceSumProvider.notifier);

//       //final index = items.indexWhere((item) => item.dish_id == dishId);
//       final index = ref
//           .read(cartProvider.notifier)
//           .state
//           .indexWhere((element) => element.dish_id == dishId);
//       if (index != -1) {
//         if (items[index].quantity > 1) {
//           items[index].quantity--;
//           items[index].tprice = 0;
//           items[index].tprice = items[index].quantity * price;
//           print(items[index].tprice);

//           await supabaseClient.from('cart').update({
//             'quantity': ref.read(cartProvider.notifier).state[index].quantity,
//             'tprice': ref.read(cartProvider.notifier).state[index].tprice,
//           }).eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
//         } else {
//           await supabaseClient
//               .from('cart')
//               .delete()
//               .eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
//           if (items.isNotEmpty) {
//             items.removeAt(index);
//           }
//         }
//       }

//       cart.state = List.from(items); // Update state
//       cartTPrice.state = getTotalPrice(ref);
//       print('car total price check ${cartTPrice.state}');
//     });
//   }

  //remove cartitem
//   Future<void> removeItem(WidgetRef ref, String dishId) async {
//     final cart = ref.read(cartProvider.notifier);
//     final items = cart.state;
//     final cartTPrice = ref.read(cartPriceSumProvider.notifier);

//     await supabaseClient.from('cart').delete().eq('dish_id', dishId);

//     items.removeWhere((item) => item.dish_id == dishId);

//     cart.state = List.from(items); // Update state
//     cartTPrice.state = getTotalPrice(ref);
//     print('car total price check ${cartTPrice.state}');
//   }
// //increse quantity in basket

//   Future<void> increaseQuantityBasket(
//       {required int cartid, required WidgetRef ref, required price}) async {
//     try {
//       final cart = ref.read(cartProvider.notifier);
//       final items = cart.state;
//       final index = items.indexWhere((element) => element.cart_id == cartid);
//       final cartTPrice = ref.read(cartPriceSumProvider.notifier);

//       if (index != -1) {
//         items[index].quantity++;
//         final result = items[index].quantity * price;
//         items[index].tprice = result.toDouble();
//         await supabaseClient.from('cart').update({
//           'quantity': items[index].quantity,
//           'tprice': items[index].tprice,
//         }).eq('id', cartid);

//         cart.state = List.from(items);
//         cartTPrice.state = getTotalPrice(ref);
//       }
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//remove item in basket

  // Future<void> removeItemFromBasket({
  //   required int cartid,
  //   required WidgetRef ref,
  // }) async {
  //   try {
  //     final cart = ref.read(cartProvider.notifier);
  //     final items = cart.state;
  //     final index = items.indexWhere((element) => element.cart_id == cartid);
  //     final cartTPrice = ref.read(cartPriceSumProvider.notifier);

  //     if (index != -1) {
  //       items.removeWhere((element) => element.cart_id == cartid);

  //       await supabaseClient.from('cart').delete().eq('id', cartid);

  //       cart.state = List.from(items);
  //       cartTPrice.state = getTotalPrice(ref);
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  //calculate total pirce
  double getTotalPrice(WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return cart.fold(0.0,
        (previousValue, element) => previousValue + (element.tprice ?? 0.0));
  }

  //   cart.fold(0.0, (previousValue, element) {
  //     if (element.variation != null) {
  //       for (var items in element.variation!) {
  //         variationtotal = items.variationPrice! * element.quantity;
  //       }
  //     }
  //     return variationtotal;
  //   });
  //   sum = alltprices + variationtotal;
  //   return sum;
  // }

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

  // Future<void> initializeCart(WidgetRef ref, String userId, context) async {
  //   final cartNotifier = ref.read(cartProvider.notifier);

  //   try {
  //     // 1. Check if SQLite has data
  //     final localItems = await _database.getCartItems(userId);

  //     if (localItems.isEmpty) {
  //       // 2. If empty, sync from Supabase
  //       await syncCartFromSupabase(userId);
  //     }

  //     // 3. Load from SQLite to state
  //     final finalItems = await _database.getCartItems(userId);
  //     cartNotifier.state = finalItems;

  //     // 4. Start background sync
  //     // unawaited(repository.syncPendingChanges());
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed Initialize Data ${e.toString()}')));
  //   }
  // }

  Future<void> deleteCartItem(
      {required cartItemId, required WidgetRef ref}) async {
    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final priceNotifier = ref.read(cartPriceSumProvider.notifier);
      final currentCart = cartNotifier.state;

      final index =
          currentCart.indexWhere((item) => item.cart_id == cartItemId);

      if (index == -1) return;
      debugPrint("Reomoved $cartItemId");
      await _database.deleteCartItem(cartItemId);

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
