import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Cart/model/Cartmodel.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

var dishMenuRepoProvider = Provider((ref) => DishMenuRepository());
var variationProvider = StateProvider<Map<int, List<Variation>?>>((ref) => {});
var dishesListProvider = StateProvider<List<DishData>?>((ref) => []);

class DishMenuRepository {
//fetch variations
  Future<List<VariattionTitleModel>?> fetchVariations(
      {required int dishid, required context}) async {
    try {
      final response = await supabaseClient
          .from('titleVariations')
          .select(
              'id , title, isRequired, subtitle,maxSeleted,dishid, variations(id,variation_name,variation_price,variation_id)')
          .eq('dishid', dishid);

      if (response.isNotEmpty) {
        final variationList =
            response.map((e) => VariattionTitleModel.fromjson(e)).toList();
        return variationList;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      // throw Exception(e);
    }
    return null;
  }

  Future<List<VariattionTitleModel>?> fetchTitleVariation(
    BuildContext context, {
    required var dishid,
  }) async {
    try {
      final res = await supabaseClient.from('titleVariations').select(
          'id , title, isRequired, subtitle,maxSeleted,dishid, variations(id,variation_name,variation_price,variation_id)');

      if (res.isNotEmpty) {
        final titleVariationList =
            res.map((e) => VariattionTitleModel.fromjson(e)).toList();
        return titleVariationList;
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString())));
      throw Exception(e);
    }
    return null;
  }

  Future<List<DishData>?> fetchfrequentlybuy({
    required int? freqid,
    required WidgetRef ref,
    // required List<DishData> dishes,
  }) async {
    List<DishData> allfreqbuydishes = [];
    List<DishData> items = [];
    if (freqid != null) {
      print("if freq is not null");
      try {
        final res = await supabaseClient
            .from('frequently_bought')
            .select('freq_bought')
            .eq('id', freqid)
            .single();
        if (res.isEmpty) return [];
        final frequentlybuyList = List<int>.from(res['freq_bought']);
        for (var dish in frequentlybuyList) {
        
          items = ref
              .read(dishesListProvider.notifier)
              .state!
              .where((element) => element.dishid == dish)
              .toList();
          print("freq ${items.length}");
          allfreqbuydishes.addAll(items);
        }
        print("freq again${items.length}");
        print("allfreq list${allfreqbuydishes.length}");
        return allfreqbuydishes;
        // ref.read(freqDishesProvider.notifier).state = allfreqbuydishes;
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    return null;
  }

  void addAllFreqBoughtItems({
    required WidgetRef ref,
    required String restaurantId,
    required String restaurantName,
  }) {
    final freqItems = ref.watch(freqnewListProvider.notifier).state;
    if (freqItems != null && freqItems.isNotEmpty) {
      for (int i = 0;
          i < ref.watch(freqnewListProvider.notifier).state!.length;
          i++) {
        final freq = ref.watch(freqnewListProvider.notifier).state!;
        ref.read(cartReopProvider).addCartItem(
         restaurantName: restaurantName,
          restaurantId: restaurantId,
            itemprice: freq[i].dish_price!,
            name: freq[i].dish_name,
            description: freq[i].dish_description,
            ref: ref,
            userId: supabaseClient.auth.currentUser!.id,
            dishId: freq[i].dishid!,
            discountprice: freq[i].dish_discount ?? 0,
            price: freq[i].dish_price,
            image: freq[i].dish_imageurl!,
            variations: null,
            isdishScreen: false,
            quantity: 1,
            freqboughts: null);
          
      }
      ref.read(freqnewListProvider.notifier).state=[];
    }
  }

  Future<void> dishesCrud(
      {required WidgetRef ref,
      bool? isdishmenuScreen,
      required bool isCart,
      required int updatedQuantity,
      required DishData dish,
      required Cartmodel cart,
      required int quantity,
      required String restaurantId,
      required String restaurantName,
      required context}) async {
    final cartItem = ref.watch(cartProvider);
    final index = cartItem.indexWhere((item) => (item as Cartmodel).cart_id == cart.cart_id);

    if (isCart && updatedQuantity > 0) {
      await ref.read(cartReopProvider).updateCartItems(
          cartId: cart.cart_id!,
          ref: ref,
          price: dish.dish_price!,
          newQuantity: updatedQuantity,
          newVariations: []);
    } else if (updatedQuantity < 1 && isCart) {
      await ref
          .read(cartReopProvider)
          .deleteCartItem(dishId: dish.dishid!, ref: ref);
    } else if (index == -1) {
      await ref.read(cartReopProvider).addCartItem(
        restaurantId: restaurantId,
         restaurantName: restaurantName,
          itemprice: dish.dish_price!,
          name: dish.dish_name,
          description: dish.dish_description,
          ref: ref,
          userId: supabaseClient.auth.currentUser!.id,
          dishId: dish.dishid!,
          discountprice: dish.dish_discount ?? 0,
          price: dish.dish_price,
          image: dish.dish_imageurl!,
          variations: null,
          isdishScreen: false,
          quantity: quantity,
          freqboughts: null);
    } else {
      await ref.read(cartReopProvider).updateCartItems(
          cartId: cart.cart_id!,
          ref: ref,
          price: dish.dish_price!,
          newQuantity: cartItem[index].quantity += quantity,
          newVariations: []);
    }
  }

  Future<void> dishMenuCrud(
      {
      // required double totalVaritionPrice,
      required List<Variation>? variations,
      required List<DishData>? newFreqList,
      required WidgetRef ref,
      required bool withvariation,
      required Debouncer debouncer,
      bool? isdishmenuScreen,
      required bool isCart,
      required int updatedQuantity,
      required DishData dish,
      required Cartmodel cart,
      required int quantity,
      required String restaurantId,
      required String restaurantName,
      required context}) async {
    debouncer.run(() async {
      if (withvariation && isCart == true && updatedQuantity > 0) {
        debugPrint("variation length ${variations?.length}");
        await ref.read(cartReopProvider).updateCartItems(
            cartId: cart.cart_id!,
            ref: ref,
            price: dish.dish_price!,
            newQuantity: updatedQuantity,
            newVariations: variations!);
      } else if (withvariation && isCart == false && quantity > 0) {
        await ref.read(cartReopProvider).addCartItem(
          restaurantName: restaurantName,
           restaurantId: restaurantId,
            withVariation: true,
            itemprice: dish.dish_price!,
            name: dish.dish_name,
            description: dish.dish_description,
            ref: ref,
            userId: supabaseClient.auth.currentUser!.id,
            dishId: dish.dishid!,
            discountprice: dish.dish_discount ?? 0,
            price: dish.dish_price,
            image: dish.dish_imageurl!,
            variations: variations,
            isdishScreen: false,
            quantity: quantity,
            freqboughts: newFreqList);
      } else if (isCart == true &&
          withvariation == true &&
          updatedQuantity == 0) {
        await ref
            .read(cartReopProvider)
            .deleteCartItem(dishId: dish.dishid!, ref: ref);
      }

      ref.read(dishMenuRepoProvider).addAllFreqBoughtItems(ref: ref,restaurantId: restaurantId,restaurantName:restaurantName );
    });
  }
}
