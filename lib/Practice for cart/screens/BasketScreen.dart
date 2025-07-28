import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/commons/basketcard.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

class BasketScreen extends ConsumerStatefulWidget {
  List<DishData> dishes = [];
  static const String routename = "/Dummy_basket";

  RestaurantModel restaurantData;
  BasketScreen({
    super.key,
    //required this.cart,
    required this.dishes,
    required this.restaurantData,
  });
  // List<New> cart = [];

  @override
  ConsumerState<BasketScreen> createState() => _DummyBasketState();
}

class _DummyBasketState extends ConsumerState<BasketScreen> {
  bool isloader = true;
  @override
  Widget build(BuildContext context) {
    final dishesList = ref.watch(dishesListProvider);
    final userId = supabaseClient.auth.currentUser!.id;
    var carttotalamount = ref.read(cartReopProvider).getTotalPrice(ref);
    final cart = ref.watch(cartProvider);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(
            context,
            RestaurantMenuScreen.routename,
            arguments: widget.restaurantData,
          ),
        ),
        title: const Text(
          'Your Basket',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: cart.isEmpty && carttotalamount == 0
          ? const Center(
              child: Text(
              'No Item in cart',
              style: TextStyle(fontSize: 24),
            ))
          : Column(
              children: [
                // Scrollable ListView
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final cartitem = cart[index];
                            final dishindex = widget.dishes.firstWhere(
                              (dish) => dish.dishid == cart[index].dish_id,
                              orElse: () => DishData(isVariation: false),
                            );
                            return InkWell(
                              onTap: () {
                                if (dishindex.isVariation) {
                                  Navigator.pushNamed(
                                      context, DishMenuVariation.routename,
                                      arguments: {
                                        'isdishscreen': false,
                                        'dishes': dishesList,
                                        'dish': dishindex,
                                        'iscart': true,
                                        'cartdish': cartitem,
                                        'restaurantData': ref
                                            .read(restaurantProvider.notifier)
                                            .state,
                                        'carts': cart,
                                      });
                                } else {
                                  Navigator.pushNamed(
                                      context, DishMenuScreen.routename,
                                      arguments: {
                                        'dishes': dishesList,
                                        'dish': dishindex,
                                        'iscart': true,
                                        'cartdish': cartitem,
                                        'isdishscreen': false
                                      });
                                }
                              },
                              child: BasketCard(
                                  titleVariationList: [],
                                  cardHeight: 150,
                                  elevation: 0,
                                  cardColor: Colors.white,
                                  dish: dishindex,
                                  imageHeight: 100,
                                  imageWidth: 100,
                                  cartItem: cartitem,
                                  userId: userId,
                                  isCartScreen: false,
                                  quantityIndex: index),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Sticky "Total" Section at the Bottom

                Container(
                  height: 180,
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(6, 6),
                            spreadRadius: 1,
                            blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Platform fee'),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.black,
                              child: const Text('\$2.0',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              color: Colors.black,
                              child: Text(
                                '\$${carttotalamount}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, PaymentScreen.routename),
                              child: const Text(
                                "PROCEED TO CHECKOUT",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ));
  }
}
