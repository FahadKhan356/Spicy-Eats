import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/main.dart';

var cartProvider = StateProvider<List<CartModelNew>>((ref) => []);
var DummyLogicProvider = Provider((ref) => Dummylogics());

class Dummylogics {
  //fetch cart
  Future<void> fetchCart(WidgetRef ref, String userId) async {
    final userId = supabaseClient.auth.currentUser!.id;

    if (userId.isEmpty) return;

    final response =
        await supabaseClient.from('cart').select().eq('user_id', userId);

    if (response.isNotEmpty) {
      List<CartModelNew> cartItems =
          response.map((json) => CartModelNew.fromjson(json)).toList();
      ref.read(cartProvider.notifier).state = cartItems;
      print("cart fetched");
    }
  }

  //addtocart
  Future<void> addToCart(
      WidgetRef ref, String userId, String dishId, double price) async {
    final cart = ref.read(cartProvider.notifier);
    final items = cart.state;

    final index = items.indexWhere((item) => item.dish_id == dishId);

    if (index != -1) {
      // If item exists, update quantity
      items[index].quantity++;

      await supabaseClient.from('cart').update({
        'quantity': items[index].quantity,
        'total_price': items[index].tprice,
      }).eq('id', items[index].cart_id!);
    } else {
      // Insert new item
      final response = await supabaseClient.from('cart').insert({
        'user_id': userId,
        'dish_id': dishId,
        'quantity': 1,
        'tprice': price
      }).select();

      if (response.isNotEmpty) {
        final newItem = CartModelNew.fromjson(response.first);
        items.add(newItem);
      }
    }

    cart.state = List.from(items); // Update state
  }

//increase quantity
  Future<void> increaseQuantity(WidgetRef ref, int dishId) async {
    // print('inside the increase quantity..');
    final cart = ref.read(cartProvider.notifier);
    final items = cart.state;
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

      ref.watch(cartProvider.notifier).state[index].quantity++;
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
    print('ended the increase quantity..');
  }

//decrease qunatity
  Future<void> decreaseQuantity(WidgetRef ref, int? dishId) async {
    final cart = ref.read(cartProvider.notifier);
    final items = cart.state;

    final index = items.indexWhere((item) => item.dish_id == dishId);

    if (index != -1) {
      if (items[index].quantity > 1) {
        items[index].quantity--;

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
  }

  //remove cartitem
  Future<void> removeItem(WidgetRef ref, String dishId) async {
    final cart = ref.read(cartProvider.notifier);
    final items = cart.state;

    await supabaseClient.from('cart').delete().eq('dish_id', dishId);

    items.removeWhere((item) => item.dish_id == dishId);

    cart.state = List.from(items); // Update state
  }

  //calculate total pirce
  double getTotalPrice(WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return cart.fold(0, (sum, item) => sum + item.tprice!);
  }
}
