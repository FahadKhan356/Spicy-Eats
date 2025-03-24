import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
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

// update cart

  Future<void> updateCart(WidgetRef ref, int dishId, double price,
      List<Variation>? variations, quantity) async {
    final cart = ref.read(cartProvider.notifier);
    final item = cart.state;
    final cartTprice = ref.read(cartPriceSumProvider.notifier);

    final index = item.indexWhere((element) => element.dish_id == dishId);
    if (index != -1) {
      item[index].quantity = quantity;
      final totalprice = item[index].itemprice * quantity;
      item[index].variation != variations;
      final response = await supabaseClient.from('cart').update({
        'quantity': quantity,
        'variations': variations != null
            ? variations.map((e) => e.tojson()).toList()
            : [],
        'tprice': totalprice,
      }).eq('id', item[index].cart_id!);

      if (response != null) {
        final items = response.map((e) => CartModelNew.fromjson(e)).toList();
        item.add(items);
      }
    }
    cart.state = List.from(item);
    cartTprice.state = getTotalPrice(ref);
    print('car total price check ${cartTprice.state}');
  }

  //addtocart
  Future<void> addToCart(
    double itemprice,
    name,
    description,
    WidgetRef ref,
    String userId,
    int dishId,
    double? discountprice,
    double? price,
    String image,
    List<Variation>? variations,
    bool isdishScreen,
    int quantity,
    List<DishData>? freqboughts,
  ) async {
    await _mutex.run(() async {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      final index = items.indexWhere((item) => item.dish_id == dishId);

      if (index != -1 && variations == null) {
        //If item exists, update quantity
        items[index].quantity++;
        items[index].tprice = discountprice != null
            ? items[index].quantity * discountprice
            : items[index].quantity * price!;
        await supabaseClient.from('cart').update({
          'quantity': items[index].quantity,
          'tprice': items[index].tprice,
        }).eq('id', items[index].cart_id!);
      } else {
        final itemquantity = discountprice != null
            ? quantity * discountprice
            : quantity * price!;

        // final allvariationtotal = items[index].variation!.fold(
        //     0,
        //     (previousValue, element) =>
        //         previousValue + element.variationPrice!.toInt());
        // print('all variation total is ${allvariationtotal}');
        // Insert new item
        final response = await supabaseClient.from('cart').insert({
          'user_id': userId,
          'dish_id': dishId,
          'quantity': quantity,
          'tprice': itemquantity,
          'image': image,
          'itemprice': itemprice,
          'name': name,
          'description': description,
          'variations': variations != null
              ? variations.map((v) => v.tojson()).toList()
              : [],
          'frequently_boughtList': freqboughts != null
              ? freqboughts.map((e) => e.tojson()).toList()
              : []
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
  Future<void> increaseQuantity(WidgetRef ref, int dishId, double price) async {
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

  //deccrese quantity in basket

  Future<void> decreaseQuantityBasket(
      {required int cartid, required WidgetRef ref, required price}) async {
    await _mutex.run(() async {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final index = items.indexWhere((element) => element.cart_id == cartid);
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index].quantity--;
          final result = items[index].quantity * price;
          items[index].tprice = result.toDouble();
          await supabaseClient.from('cart').update({
            'quantity': items[index].quantity,
            'tprice': items[index].quantity * price,
          }).eq('id', items[index].cart_id!);
        } else {
          await supabaseClient
              .from('cart')
              .delete()
              .eq('id', items[index].cart_id!);
          items.removeAt(index);
        }

        cart.state = List.from(items);
        cartTPrice.state = getTotalPrice(ref);
      }
    });
  }

//decrease qunatity
  Future<void> decreaseQuantity(
      WidgetRef ref, int? dishId, double price) async {
    await _mutex.run(() async {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      //final index = items.indexWhere((item) => item.dish_id == dishId);
      final index = ref
          .read(cartProvider.notifier)
          .state
          .indexWhere((element) => element.dish_id == dishId);
      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index].quantity--;
          items[index].tprice = 0;
          items[index].tprice = items[index].quantity * price;
          print(items[index].tprice);

          await supabaseClient.from('cart').update({
            'quantity': ref.read(cartProvider.notifier).state[index].quantity,
            'tprice': ref.read(cartProvider.notifier).state[index].tprice,
          }).eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
        } else {
          await supabaseClient
              .from('cart')
              .delete()
              .eq('id', ref.read(cartProvider.notifier).state[index].cart_id!);
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
//increse quantity in basket

  Future<void> increaseQuantityBasket(
      {required int cartid, required WidgetRef ref, required price}) async {
    try {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final index = items.indexWhere((element) => element.cart_id == cartid);
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      if (index != -1) {
        items[index].quantity++;
        final result = items[index].quantity * price;
        items[index].tprice = result.toDouble();
        await supabaseClient.from('cart').update({
          'quantity': items[index].quantity,
          'tprice': items[index].tprice,
        }).eq('id', cartid);

        cart.state = List.from(items);
        cartTPrice.state = getTotalPrice(ref);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//remove item in basket

  Future<void> removeitembasket({
    required int cartid,
    required WidgetRef ref,
  }) async {
    try {
      final cart = ref.read(cartProvider.notifier);
      final items = cart.state;
      final index = items.indexWhere((element) => element.cart_id == cartid);
      final cartTPrice = ref.read(cartPriceSumProvider.notifier);

      if (index != -1) {
        items.removeWhere((element) => element.cart_id == cartid);

        await supabaseClient.from('cart').delete().eq('id', cartid);

        cart.state = List.from(items);
        cartTPrice.state = getTotalPrice(ref);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //calculate total pirce
  double getTotalPrice(WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    var variationtotal = 0.0;
    var alltprices = 0.0;
    var sum = 0.0;
    alltprices = cart.fold(
        0.0, (previousValue, element) => previousValue + element.tprice!);

    cart.fold(0.0, (previousValue, element) {
      if (element.variation != null) {
        for (var items in element.variation!) {
          variationtotal = items.variationPrice! * element.quantity;
        }
      }
      return variationtotal;
    });
    sum = alltprices + variationtotal;
    return sum;
  }

  int getTotalQuantityofdish(WidgetRef ref, int dishid) {
    final cart = ref.watch(cartProvider);
    return cart.fold(
        0, (sum, item) => item.dish_id == dishid ? sum + item.quantity : sum);
  }

  // int getquantitytotal(WidgetRef ref, int dishid) {
  //   int quantity = 0;
  //   final cart = ref.watch(cartProvider);
  //   for (int i = 0; i < cart.length; i++) {
  //     if (cart[i].dish_id == dishid) {
  //       quantity += cart[i].quantity;
  //     }
  //   }
  //   return quantity;
  // }
}
