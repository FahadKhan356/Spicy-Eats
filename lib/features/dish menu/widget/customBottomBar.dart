import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/controller/dish-menu_controller.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';

Widget customBottomBar(
    bool? isnoVariation,
    bool? mounted,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
    bool isDishMenuScreen,
    bool withvariation,
    WidgetRef ref,
    double width,
    bool isCart,
    int updatedQuantity,
    context,
    DishData dish,
    int quantity,
    RestaurantModel restaurantData,
    double height,
    Debouncer debouncer,
    {required VoidCallback onAction}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(70),
    child: Container(
      height: width * 0.1,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: isDishMenuScreen && withvariation
            ? const Color.fromRGBO(230, 81, 0, 1)
            : isDishMenuScreen && !withvariation
                ? Colors.black12
                : const Color.fromRGBO(230, 81, 0, 1),
        //     gradient: LinearGradient(
        //   begin: Alignment.centerRight,
        //   end: Alignment.centerLeft,
        //   colors: [
        //     Color.fromRGBO(230, 81, 0, 1),
        //     Color.fromRGBO(230, 81, 0, 1),
        //   ],
        // )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: SizedBox(
                height: double.maxFinite,
                width: width * 0.3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: isDishMenuScreen && withvariation
                          ? const Color.fromRGBO(230, 81, 0, 1)
                          : isDishMenuScreen && !withvariation
                              ? Colors.transparent
                              : const Color.fromRGBO(230, 81, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.35 / 2),
                      )),
                  child: isCart && updatedQuantity > 0
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Update to cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : isCart && updatedQuantity < 1
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'remove to cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Add to cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                  onPressed: () => onAction(),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: double.maxFinite,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: isDishMenuScreen && withvariation
                              ? Colors.yellow.withValues(alpha: 0.6)
                              : isDishMenuScreen && !withvariation
                                  ? Colors.transparent
                                  : Colors.yellow.withValues(alpha: 0.6),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ],
                    color: isDishMenuScreen && withvariation
                        ? const Color.fromRGBO(230, 81, 0, 1)
                        : isDishMenuScreen && !withvariation
                            ? Colors.transparent
                            : const Color.fromRGBO(230, 81, 0, 1),
                    borderRadius: BorderRadius.circular((width * 0.30) / 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isnoVariation!) {
                          debugPrint('height $height width $width');
                          ref
                              .read(dishMenuControllerProvider)
                              .increaseItemQuantity(
                                isCart,
                                debouncer,
                                ref,
                              );
                        } else if (!isnoVariation && withvariation) {
                          debugPrint('height $height width $width');
                          ref
                              .read(dishMenuControllerProvider)
                              .increaseItemQuantity(
                                isCart,
                                debouncer,
                                ref,
                              );
                        } else {
                          if (scaffoldMessengerKey!.currentState != null) {
                            scaffoldMessengerKey.currentState!.showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please choose required Variation'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: 100, left: 20, right: 20),
                              ),
                            );
                          }
                        }
                      },
                      // withvariation
                      //     ? () {
                      //         debugPrint('height $height width $width');
                      //         ref
                      //             .read(dishMenuControllerProvider)
                      //             .increaseItemQuantity(
                      //               isCart,
                      //               debouncer,
                      //               ref,
                      //             );
                      //       }
                      //     : () {
                      //         if (scaffoldMessengerKey!.currentState != null) {
                      //           scaffoldMessengerKey.currentState!.showSnackBar(
                      //             const SnackBar(
                      //               content: Text(
                      //                   'Please choose required Variation'),
                      //               behavior: SnackBarBehavior.floating,
                      //               margin: EdgeInsets.only(
                      //                   bottom: 100, left: 20, right: 20),
                      //             ),
                      //           );
                      //         }
                      //       },
                      icon: Icon(
                        Icons.add,
                        size: width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    isCart
                        ? Text(
                            ref
                                .read(updatedQuantityProvider.notifier)
                                .state
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.035,
                                color: Colors.white),
                          )
                        : Text(
                            quantity.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                                color: Colors.white),
                          ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        if (isnoVariation!) {
                          debugPrint('height $height width $width');
                          ref
                              .read(dishMenuControllerProvider)
                              .decreaseItemQuantity(
                                isCart,
                                debouncer,
                                ref,
                              );
                        } else if (!isnoVariation && withvariation) {
                          debugPrint('height $height width $width');
                          ref
                              .read(dishMenuControllerProvider)
                              .decreaseItemQuantity(
                                isCart,
                                debouncer,
                                ref,
                              );
                        } else {
                          if (scaffoldMessengerKey!.currentState != null) {
                            scaffoldMessengerKey.currentState!.showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please choose required Variation'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: 100, left: 20, right: 20),
                              ),
                            );
                          }
                        }
                      },

                      // withvariation
                      // ? () {
                      //     ref
                      //         .read(dishMenuControllerProvider)
                      //         .decreaseItemQuantity(
                      //           isCart,
                      //           debouncer,
                      //           ref,
                      //         );
                      //   }
                      // : () {
                      //     if (mounted! &&
                      //         scaffoldMessengerKey!.currentState != null) {
                      //       scaffoldMessengerKey.currentState!.showSnackBar(
                      //         const SnackBar(
                      //           content: Text(
                      //               'Please choose required Variation'),
                      //           behavior: SnackBarBehavior.floating,
                      //           margin: EdgeInsets.only(
                      //               bottom: 100, left: 20, right: 20),
                      //         ),
                      //       );
                      //     }
                      //   },
                      icon: Icon(
                        Icons.remove,
                        size: width * 0.050,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
