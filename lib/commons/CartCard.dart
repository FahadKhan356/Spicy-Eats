import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';

class CartCard extends ConsumerWidget {
  CartCard({
    super.key,
    this.cardHeight,
    required this.elevation,
    required this.cardColor,
    required this.dish,
    required this.imageHeight,
    required this.imageWidth,
    required this.cartItem,
    required this.userId,
    required this.isCartScreen,
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
  });
  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final CartModelNew? cartItem;
  final String? userId;
  bool? isCartScreen;
  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;

  Debouncer _debouncer = Debouncer(milliseconds: 500);
  @override
  build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, DishMenuScreen.routename,
          arguments: {'dish': dish, 'iscart': false}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: cardHeight ?? 130,
            width: double.maxFinite,
            child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: elevation ?? 5,
                color: cardColor ?? Colors.white,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            height: imageHeight,
                            width: imageWidth,
                            child: Image.network(
                              isCartScreen!
                                  ? dish!.dish_imageurl.toString()
                                  : cartItem!.image.toString(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              // color: Colors.blue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isCartScreen!
                                        ? dish!.dish_name.toString()
                                        : cartItem!.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    isCartScreen!
                                        ? dish!.dish_description.toString()
                                        : cartItem!.description.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  isCartScreen!
                                      ? Text(
                                          '\$${dish!.dish_price!.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        )
                                      : Text(
                                          '\$${cartItem!.tprice!.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                            cartItem!.dish_id != dish!.dishid &&
                                    isCartScreen == true
                                ? InkWell(
                                    onTap: () {
                                      _debouncer.run(() {
                                        ref.read(DummyLogicProvider).addToCart(
                                              ref,
                                              userId!,
                                              dish!.dishid.toString(),
                                              dish!.dish_price!.toDouble(),
                                              dish!.dish_imageurl!,
                                            );
                                      });
                                    },
                                    child: Container(
                                      height: addbuttonHeight ?? 50,
                                      width: addbuttonWidth ?? 50,
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 6,
                                                offset: Offset(-1, -1),
                                                spreadRadius: 1)
                                          ],
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _debouncer.run(() {
                                                ref
                                                    .read(DummyLogicProvider)
                                                    .increaseQuantity(
                                                      ref,
                                                      dish!.dishid!,
                                                      dish!.dish_price!,
                                                    );
                                              });
                                            },
                                            child: Container(
                                              height: buttonIncDecHeight ?? 50,
                                              width: buttonIncDecHeight ?? 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))),
                                              child: const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          //cartItem.quantity.toString(),
                                          ref
                                              .read(cartProvider.notifier)
                                              .state[quantityIndex!]
                                              .quantity
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _debouncer.run(() {
                                                ref
                                                    .read(DummyLogicProvider)
                                                    .decreaseQuantity(
                                                      ref,
                                                      dish!.dishid!,
                                                      dish!.dish_price!,
                                                    );
                                              });
                                            },
                                            child: Container(
                                              height: buttonIncDecHeight ?? 50,
                                              width: buttonIncDecWidth ?? 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Center(
                                                  child: isCartScreen ==
                                                              false &&
                                                          cartItem!.quantity ==
                                                              1
                                                      ? const Icon(
                                                          Icons.delete_rounded,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .minimize_outlined,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
