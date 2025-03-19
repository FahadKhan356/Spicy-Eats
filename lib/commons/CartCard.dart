import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/cart%20example/basketpage.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVAriation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

class CartCard extends ConsumerStatefulWidget {
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
    required this.quantityIndex,
    this.addbuttonHeight,
    this.addbuttonWidth,
    this.buttonIncDecHeight,
    this.buttonIncDecWidth,
    required this.titleVariationList,
  });
  final double? cardHeight;
  final double? elevation;
  final Color? cardColor;
  final DishData? dish;
  final double? imageHeight;
  final double? imageWidth;
  final CartModelNew? cartItem;
  final String? userId;

  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<CartCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<CartCard> {
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

  void addtocart({
    required DishData dish,
  }) {
    final isInCart = ref
        .read(cartProvider.notifier)
        .state
        .indexWhere((element) => element.dish_id == dish.dishid);
    if (isInCart == -1) {
      ref.read(DummyLogicProvider).addToCart(
          dish.dish_price!,
          dish.dish_name,
          dish.dish_description,
          ref,
          supabaseClient.auth.currentUser!.id,
          dish.dishid!,
          dish.dish_price!.toDouble(),
          dish.dish_imageurl!,
          [],
          false,
          1);
    }
    expandbutton();
  }

  void increaseQuantity({required int dishid}) {
    // final isInCart=ref.read(cartProvider.notifier).state.indexWhere((element) => element.dish_id==dishid);
    //  if(isInCart!=-1){
    ref
        .read(DummyLogicProvider)
        .increaseQuantity(ref, widget.dish!.dishid!, widget.dish!.dish_price!);
    //  }
    startcollapseTimer();
  }

  void decreaseQuantity({required int dishid}) {
    // final isInCart=ref.read(cartProvider.notifier).state.indexWhere((element) => element.dish_id==dishid);
    //  if(isInCart!=-1){
    ref
        .read(DummyLogicProvider)
        .decreaseQuantity(ref, widget.dish!.dishid!, widget.dish!.dish_price!);
    //  }
    startcollapseTimer();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final cart = widget.cartItem;
    final dish = widget.dish;
    final cartlistener = ref.watch(cartProvider);
    final index =
        cartlistener.indexWhere((element) => element.dish_id == dish!.dishid!);
    final quantity =
        ref.read(DummyLogicProvider).getTotalQuantityofdish(ref, dish!.dishid!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          height: widget.cardHeight ?? 130,
          width: double.maxFinite,
          child: Card(
              surfaceTintColor: const Color.fromRGBO(189, 189, 189, 1),
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 1, // widget.elevation ?? 5,
              color: widget.cardColor ?? Colors.white,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // AnimatedAddButton(),
                          Container(
                            // color: Colors.red,
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                            child: Image.network(
                              widget.dish!.dish_imageurl.toString(),
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
                                    widget.dish!.dish_name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.dish!.dish_description.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '\$${widget.dish!.dish_price!.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )
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
                                        });
                                    // }
                                  });
                                },
                                child: Container(
                                  height: widget.addbuttonHeight ?? 40,
                                  width: widget.addbuttonWidth ?? 40,
                                  decoration: const BoxDecoration(
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.black54,
                                      //       blurRadius: 6,
                                      //       offset: Offset(-1, -1),
                                      //       spreadRadius: 1)
                                      // ],
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: cart!.dish_id == dish.dishid &&
                                            dish.isVariation!
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
                              // && cart!.dish_id != dish.dishid)
                              AnimatedContainer(
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                width: 40,
                                height: isExpanded ? 100 : 40,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 300),
                                child: isExpanded
                                    ? FittedBox(
                                        child: Column(
                                          children: [
                                            iconButton(Icons.add, () {
                                              final currentcarmodel =
                                                  cartlistener.firstWhere(
                                                      (e) =>
                                                          e.dish_id ==
                                                          dish.dishid,
                                                      orElse: () =>
                                                          CartModelNew(
                                                              quantity: 1));

                                              print(currentcarmodel.cart_id);
                                              increaseQuantity(
                                                  dishid: dish.dishid!);
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
                                                        key: ValueKey<int>(
                                                            quantity),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : const Text(
                                                        '0',
                                                        key: ValueKey<int>(0),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )),
                                            iconButton(Icons.remove, () {
                                              decreaseQuantity(
                                                  dishid: dish.dishid!);
                                            })
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          addtocart(dish: dish);
                                        },
                                        child: cartlistener.any((element) =>
                                                element.dish_id == dish.dishid)
                                            ? Container(
                                                height: 40,
                                                width: 40,
                                                decoration: const BoxDecoration(
                                                    // color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
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
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )),
                              ),

                            // InkWell(
                            //   onTap: () async {
                            //     _debouncer.run(() async {
                            //       ref.read(DummyLogicProvider).addToCart(
                            //           widget.dish!.dish_price,
                            //           widget.dish!.dish_name,
                            //           widget.dish!.dish_description,
                            //           ref,
                            //           supabaseClient.auth.currentUser!.id,
                            //           widget.dish!.dishid!,
                            //           widget.dish!.dish_price!.toDouble(),
                            //           widget.dish!.dish_imageurl!,
                            //           null,
                            //           false,
                            //           1);
                            //     });
                            //   },
                            //   child: Container(
                            //     height: widget.addbuttonHeight ?? 50,
                            //     width: widget.addbuttonWidth ?? 50,
                            //     decoration: const BoxDecoration(
                            //         // boxShadow: [
                            //         //   BoxShadow(
                            //         //       color: Colors.black54,
                            //         //       blurRadius: 6,
                            //         //       offset: Offset(-1, -1),
                            //         //       spreadRadius: 1)
                            //         // ],
                            //         color: Colors.black,
                            //         borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(10),
                            //             bottomRight: Radius.circular(10))),
                            //     child: const Align(
                            //       alignment: Alignment.center,
                            //       child: Icon(
                            //         Icons.add,
                            //         size: 20,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // if (dish.isVariation == false &&
                            //     cart!.dish_id == dish.dishid)
                            //   Expanded(
                            //     child: Column(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Expanded(
                            //           child: InkWell(
                            //             onTap: () {
                            //               _debouncer.run(() {
                            //                 ref
                            //                     .read(DummyLogicProvider)
                            //                     .increaseQuantity(
                            //                       ref,
                            //                       widget.dish!.dishid!,
                            //                       widget.dish!.dish_price!,
                            //                     );
                            //               });
                            //             },
                            //             child: Container(
                            //               height:
                            //                   widget.buttonIncDecHeight ?? 50,
                            //               width:
                            //                   widget.buttonIncDecHeight ?? 50,
                            //               decoration: const BoxDecoration(
                            //                   color: Colors.black,
                            //                   borderRadius: BorderRadius.only(
                            //                       topRight: Radius.circular(10),
                            //                       bottomLeft:
                            //                           Radius.circular(10))),
                            //               child: const Icon(
                            //                 Icons.add,
                            //                 size: 20,
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         const SizedBox(width: 5),
                            //         Text(
                            //           ref
                            //               .read(cartProvider.notifier)
                            //               .state[widget.quantityIndex!]
                            //               .quantity
                            //               .toString(),
                            //         ),
                            //         // Text(
                            //         //     style: const TextStyle(fontSize: 20),
                            //         //     cartlistener
                            //         //         .where((element) =>
                            //         //             element.dish_id == dish.dishid)
                            //         //         .length
                            //         //         .toString()),
                            //         const SizedBox(width: 5),
                            //         Expanded(
                            //           child: InkWell(
                            //             onTap: () {
                            //               _debouncer.run(() {
                            //                 ref
                            //                     .read(DummyLogicProvider)
                            //                     .decreaseQuantity(
                            //                       ref,
                            //                       widget.dish!.dishid!,
                            //                       widget.dish!.dish_price!,
                            //                     );
                            //               });
                            //             },
                            //             child: Container(
                            //               height:
                            //                   widget.buttonIncDecHeight ?? 50,
                            //               width: widget.buttonIncDecWidth ?? 50,
                            //               decoration: const BoxDecoration(
                            //                   color: Colors.black,
                            //                   borderRadius: BorderRadius.only(
                            //                       topLeft: Radius.circular(10),
                            //                       bottomRight:
                            //                           Radius.circular(10))),
                            //               child: Center(
                            //                   child:
                            //                       widget.cartItem!.quantity == 1
                            //                           ? const Icon(
                            //                               Icons.delete_rounded,
                            //                               size: 20,
                            //                               color: Colors.white,
                            //                             )
                            //                           : const Icon(
                            //                               Icons
                            //                                   .minimize_outlined,
                            //                               size: 20,
                            //                               color: Colors.white,
                            //                             )),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            // )
                          ])),
                    )
                  ]))),
    );
  }
}

Widget iconButton(IconData icon, VoidCallback onpress) {
  return InkWell(
    onTap: onpress,
    child: Container(
      decoration: const BoxDecoration(
          // color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
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
