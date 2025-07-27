import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Basket/model/CartModel.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

var cartControllerProvider = Provider((ref) {
  final cartRepo = ref.read(cartReopProvider);
  return CartController(cartRepo: cartRepo);
});

class CartController {
  final CartRepository cartRepo;
  CartController({required this.cartRepo});

//Fro Updating Cart
  Future<void> updateCart({ref, dishId, price, variations, quantity}) async {
    cartRepo.updateCart(ref, dishId, price, variations, quantity);
  }

//Remove From Basket if quantity becomes 0 when return to Dish Menu/Dish Menu Variation Screen again from Basket Screen
  Future<void> removeItemFromBasket({cartId, ref}) async {
    cartRepo.removeItemFromBasket(cartid: cartId, ref: ref);
  }

//Add to Cart
  Future<void> addToCart(
      {required itemPrice,
      required name,
      required description,
      required ref,
      required userId,
      required dishId,
      required discountPrice,
      required price,
      required image,
      required variations,
      required isDishScreen,
      required int quantity,
      required freqboughts}) async {
    cartRepo.addToCart(
        itemPrice,
        name,
        description,
        ref,
        userId,
        dishId,
        discountPrice,
        price,
        image,
        variations,
        isDishScreen,
        quantity,
        freqboughts);
    debugPrint("qunatity Add To Cart: $quantity");
  }

//Complete Add, Update and Remove Function for Cart

  Future<void> itemAddUpdateRemoveCart(
      {required ref,
      required Debouncer debouncer,
      required void Function(VoidCallback fn) refreshUI,
      required bool isLoading,
      required bool isCart,
      required int updatedquantity,
      required DishData dish,
      required CartModelNew cartDish,
      required int quantity,
      required BuildContext context}) async {
    debouncer.run(() async {
      refreshUI(() {
        isLoading = true;
      });

      if (isCart && updatedquantity > 0) {
        await ref.read(cartControllerProvider).updateCart(
            ref: ref,
            dishId: dish.dishid!,
            price: dish.dish_price!,
            variations: null,
            quantity: updatedquantity);
      } else if (updatedquantity == 0 && isCart) {
        await ref
            .read(cartControllerProvider)
            .removeItemFromBasket(cartId: cartDish.cart_id!, ref: ref);
      } else {
        await ref.read(cartControllerProvider).addToCart(
            itemPrice: dish.dish_price!,
            name: dish.dish_name,
            description: dish.dish_description,
            ref: ref,
            userId: supabaseClient.auth.currentUser!.id,
            dishId: dish.dishid!,
            discountPrice: dish.dish_discount,
            price: dish.dish_price!.toDouble(),
            image: dish.dish_imageurl!,
            variations: null,
            isDishScreen: true,
            quantity: quantity,
            freqboughts: null);

        if (ref.read(freqDishesProvider) != null) {
          for (int i = 0; i < ref.read(freqDishesProvider)!.length; i++) {
            final freqDish = ref.read(freqDishesProvider.notifier).state;
            await ref.read(cartControllerProvider).addToCart(
                itemPrice: freqDish![i].dish_price!,
                name: freqDish[i].dish_name,
                description: freqDish[i].dish_description,
                ref: ref,
                userId: supabaseClient.auth.currentUser!.id,
                dishId: freqDish[i].dishid,
                discountPrice: freqDish[i].dish_discount,
                price: freqDish[i].dish_price,
                image: freqDish[i].dish_imageurl,
                variations: null,
                isDishScreen: false,
                quantity: 1,
                freqboughts: null);
          }
        }
      }
    });
    Navigator.pushNamed(
      context,
      RestaurantMenuScreen.routename,
      arguments: ref.read(restaurantProvider.notifier).state,
    );
    refreshUI(() {
      isLoading = false;
    });
    debugPrint("qunatity Controller: $quantity");
  }
}
