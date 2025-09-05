import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

class BuildDishItem extends ConsumerStatefulWidget {
  BuildDishItem({
    super.key,
    this.cardHeight,
    required this.elevation,
    required this.cardColor,
    required this.dish,
    required this.imageHeight,
    required this.imageWidth,
    required this.cartItem,
    required this.userId,
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
    required this.titleVariationList,
    required this.restaurantdata,
  });

  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final Cartmodel? cartItem;
  final String? userId;
  final RestaurantModel restaurantdata;

  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  final List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<BuildDishItem> createState() => _BuildDishItemState();
}

class _BuildDishItemState extends ConsumerState<BuildDishItem> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  bool isExpanded = false;
  Timer? _timerCollapse;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerCollapse?.cancel();
  }

  void expandbutton() {
    setState(() {
      isExpanded = true;
      startcollapseTimer();
    });
  }

  void startcollapseTimer() {
    _timerCollapse?.cancel();
    _timerCollapse = Timer(const Duration(seconds: 2), () {
      setState(() {
        isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cartItem;
    final dish = widget.dish;
    final cartlistener = ref.watch(cartProvider);
    final index =
        cartlistener.indexWhere((element) => element.dish_id == dish!.dishid!);

    final quantity =
        ref.read(cartReopProvider).getTotalQuantityofdish(ref, dish!.dishid!);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.dish?.isVeg != null
                        ? Icon(
                            widget.dish!.isVeg!
                                ? Icons.crop_square
                                : Icons.stop,
                            color:
                                widget.dish!.isVeg! ? Colors.green : Colors.red,
                            size: 16,
                          )
                        : const Icon(Icons.more_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.dish!.dish_name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.dish!.dish_description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.dish!.dish_price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Container(
                      // color: Colors.amber,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        if (dish.isVariation == true) ...[
                          InkWell(
                            onTap: () async {
                              _debouncer.run(() async {
                                Navigator.pushNamed(
                                    context, DishMenuVariation.routename,
                                    arguments: {
                                      'dish': widget.dish,
                                      'iscart': false,
                                      'cartdish': widget.cartItem,
                                      'isbasket': false,
                                      'isdishscreen': true,
                                      'restaurantdata': widget.restaurantdata,
                                    });
                                // }
                              });
                            },
                            child: Container(
                              height: widget.addbuttonHeight ?? 40,
                              width: widget.addbuttonWidth ?? 40,
                              decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.black54,
                                //       blurRadius: 6,
                                //       offset: Offset(-1, -1),
                                //       spreadRadius: 1)
                                // ],
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: cart!.dish_id == dish.dishid &&
                                        dish.isVariation
                                    ? Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    : const Icon(
                                        Icons.add,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox()
                        ],
                        if (dish.isVariation == false)
                          //&& cart!.dish_id != dish.dishid)
                          AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: isExpanded ? 100 : 40,
                            height: 40,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            child: isExpanded
                                ? FittedBox(
                                    child: Row(
                                      children: [
                                        iconButton(Icons.add, () {
                                          final currentcarmodel =
                                              cartlistener.firstWhere(
                                                  (e) =>
                                                      e.dish_id == dish.dishid,
                                                  orElse: () => Cartmodel(
                                                      created_at: '',
                                                      quantity: 1));

                                          print(currentcarmodel.cart_id);
                                          // increaseQuantity(
                                          //     dishid: dish.dishid!);
                                          ref
                                              .read(cartReopProvider)
                                              .incQuantity(
                                                  ref: ref,
                                                  cartId: cart!.cart_id!,
                                                  price: dish.dish_price!);
                                        }),
                                        AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                    ),
                                            child: index != -1
                                                ? Text(
                                                    quantity.toString(),
                                                    key:
                                                        ValueKey<int>(quantity),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  )
                                                : const Text(
                                                    '0',
                                                    key: ValueKey<int>(0),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  )),
                                        iconButton(Icons.remove, () {
                                          // decreaseQuantity(
                                          //     dishid: dish.dishid!);
                                          ref
                                              .read(cartReopProvider)
                                              .decQuantity(
                                                  ref: ref,
                                                  cartId: cart!.cart_id!,
                                                  price: dish.dish_price!);
                                        })
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      final isInCart = ref
                                          .read(cartProvider.notifier)
                                          .state
                                          .indexWhere((element) =>
                                              element.dish_id == dish.dishid);
                                      if (isInCart == -1) {
                                        ref.read(cartReopProvider).addCartItem(
                                            itemprice: dish.dish_price!,
                                            name: dish.dish_name,
                                            description: dish.dish_description,
                                            ref: ref,
                                            userId: supabaseClient
                                                .auth.currentUser!.id,
                                            dishId: dish.dishid!,
                                            discountprice: dish.dish_discount,
                                            price: dish.dish_price,
                                            image: dish.dish_imageurl!,
                                            variations: null,
                                            isdishScreen: false,
                                            quantity: 1,
                                            freqboughts: null);

                                        expandbutton();
                                        // addtocart(dish: dish);
                                      } else {
                                        debugPrint(
                                            "outside before $isExpanded");
                                        setState(() {
                                          expandbutton();
                                        });
                                        debugPrint("outside after $isExpanded");
                                      }
                                    },
                                    child: cartlistener.any((element) =>
                                            element.dish_id == dish.dishid)
                                        ? Container(
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                                // color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Text(
                                                quantity.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          )),
                          ),
                      ])),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.dish!.dish_imageurl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget iconButton(IconData icon, VoidCallback onpress) {
  return InkWell(
    onTap: onpress,
    child: Container(
      decoration: BoxDecoration(
        // color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 40,
      width: 40,
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    ),
  );
}
