import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

var cartProvider = StateProvider<List<CartModelNew>>((ref) => []);
var cartPriceSumProvider = StateProvider<double>((ref) => 0);
var DummyLogicProvider = Provider((ref) => Dummylogics());

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

class Dummylogics {
  final _mutex = Mutex();
  //fetch cart
  Future<void> fetchCart(WidgetRef ref, String userId) async {
    // final userId = supabaseClient.auth.currentUser!.id;
    // final cartlist = ref.read(cartProvider.notifier);

    if (userId.isEmpty) return;

    final response =
        await supabaseClient.from('cart').select().eq('user_id', userId);

    if (response.isNotEmpty) {
      List<CartModelNew> cartItems =
          response.map((json) => CartModelNew.fromjson(json)).toList();
      ref.read(cartProvider.notifier).state = cartItems;
      // cartlist.state = List.from(cartItems);

      print("cart fetched");
    }
  }

  //addtocart
  Future<void> addToCart(
      itemprice,
      name,
      description,
      WidgetRef ref,
      String userId,
      int dishId,
      double price,
      String image,
      List<Variation>? variations,
      bool isdishScreen,
      quantity) async {
    _mutex.run(() async {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      final index = items.indexWhere((item) => item.dish_id == dishId);

      if (index != -1 && items[index].variation == null) {
        // If item exists, update quantity
        items[index].quantity++;
        items[index].tprice = items[index].quantity * price;
        await supabaseClient.from('cart').update({
          'quantity': items[index].quantity,
          'tprice': items[index].tprice,
        }).eq('id', items[index].cart_id!);
      } else {
        final itemquantity = quantity * price;

        // final allvariationtotal = items[index].variation!.fold(
        //     0,
        //     (previousValue, element) =>
        //         previousValue + element.variationPrice!.toInt());
        // print('all variation total is ${allvariationtotal}');
        // Insert new item
        final response = await supabaseClient.from('cart').insert({
          'user_id': userId,
          'dish_id': dishId,
          'quantity': isdishScreen ? quantity : 1,
          'tprice': itemquantity,
          'image': image,
          'itemprice': itemprice,
          'name': name,
          'description': description,
          'variations': variations != null
              ? variations.map((v) => v.tojson()).toList()
              : [],
        }).select();

        if (response.isNotEmpty) {
          final newItem = CartModelNew.fromjson(response.first);
          items.add(newItem);
        }
      }

      cart.state = List.from(items); // Update state
      cartTPrice.state = getTotalPrice(ref);
      print('car total price check ${cartTPrice.state}');
    });
  }

//increase quantity
  Future<void> increaseQuantity(WidgetRef ref, int dishId, int price) async {
    await _mutex.run(() async {
      // print('inside the increase quantity..');
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);
      // print('dishid given by ui: $dishId');

      final index = ref
          .read(cartProvider.notifier)
          .state
          .indexWhere((item) => item.dish_id == dishId);

      print('dishid id in index: $index');

      print('cart id: ${ref.read(cartProvider.notifier).state[index].cart_id}');

      if (index != -1) {
        print(
            'before increase quantity:${ref.read(cartProvider.notifier).state[index].quantity}');

        ref.read(cartProvider.notifier).state[index].quantity++;
        final result = items[index].quantity * price.toDouble();

        items[index].tprice = result;

        print(
            'after increase quantity:${ref.read(cartProvider.notifier).state[index].quantity}');

        await supabaseClient.from('cart').update({
          'quantity': ref.read(cartProvider.notifier).state[index].quantity,
          'tprice': ref.read(cartProvider.notifier).state[index].tprice
        }).eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
      }

      ref.read(cartProvider.notifier).state =
          List.from(ref.read(cartProvider.notifier).state);
      cart.state = List.from(items); // Update state
      cartTPrice.state = getTotalPrice(ref);
      print('ended the increase quantity..');
      print('car total price check ${cartTPrice.state}');
    });
  }

//decrease qunatity
  Future<void> decreaseQuantity(WidgetRef ref, int? dishId, int price) async {
    await _mutex.run(() async {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      final index = items.indexWhere((item) => item.dish_id == dishId);

      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index].quantity--;
          items[index].tprice = 0;
          items[index].tprice = items[index].quantity * price.toDouble();
          print(items[index].tprice);

          await supabaseClient.from('cart').update({
            'quantity': items[index].quantity,
            'tprice': items[index].tprice
          }).eq('id', items[index].cart_id!);
        } else {
          await supabaseClient
              .from('cart')
              .delete()
              .eq('id', items[index].cart_id!);
          if (items.isNotEmpty) {
            items.removeAt(index);
          }
        }
      }

      cart.state = List.from(items); // Update state
      cartTPrice.state = getTotalPrice(ref);
      print('car total price check ${cartTPrice.state}');
    });
  }

  //remove cartitem
  Future<void> removeItem(WidgetRef ref, String dishId) async {
    final cart = ref.read(cartProvider.notifier);
    final items = cart.state;
    final cartTPrice = ref.read(cartPriceSumProvider.notifier);

    await supabaseClient.from('cart').delete().eq('dish_id', dishId);

    items.removeWhere((item) => item.dish_id == dishId);

    cart.state = List.from(items); // Update state
    cartTPrice.state = getTotalPrice(ref);
    print('car total price check ${cartTPrice.state}');
  }

  //calculate total pirce
  double getTotalPrice(WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return cart.fold(0, (sum, item) => sum + item.tprice!);
  }
}
