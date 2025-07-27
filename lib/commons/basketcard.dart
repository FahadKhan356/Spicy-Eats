import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVAriation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

class BasketCard extends ConsumerStatefulWidget {
  BasketCard({
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
  bool? isCartScreen;
  int? quantityIndex;
  double? addbuttonHeight;
  double? addbuttonWidth;
  double? buttonIncDecHeight;
  double? buttonIncDecWidth;
  List<VariattionTitleModel>? titleVariationList;

  @override
  ConsumerState<BasketCard> createState() => _CartCardState();
}

class _CartCardState extends ConsumerState<BasketCard> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  build(
    BuildContext context,
  ) {
    final cart = widget.cartItem;
    final dish = widget.dish;
    final cartlistener = ref.watch(cartProvider);
    // final quantityindex=cartlistener.indexWhere((element) => element.cart_id=,)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
          height: widget.cardHeight ?? 130,
          width: double.maxFinite,
          child: Card(
              surfaceTintColor: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: widget.elevation ?? 5,
              color: widget.cardColor ?? Colors.white,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.grey[100],
                                height: widget.imageHeight,
                                width: widget.imageWidth,
                                child: Image.network(
                                  widget.cartItem!.image.toString(),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              // color: Colors.blue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.cartItem!.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // Text(
                                  //   widget.cartItem!.description.toString(),
                                  //   maxLines: 1,
                                  //   style: const TextStyle(
                                  //       fontSize: 15,
                                  //       color: Colors.black54,
                                  //       overflow: TextOverflow.ellipsis,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  // widget.isCartScreen!
                                  //     ? Text(
                                  //         '\$${widget.dish!.dish_price!.toStringAsFixed(1)}',
                                  //         style: const TextStyle(
                                  //             fontSize: 17,
                                  //             fontWeight: FontWeight.bold,
                                  //             color: Colors.red),
                                  //       )
                                  //     :
                                  Text(
                                    '\$${widget.cartItem!.tprice!.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  widget.cartItem!.variation != null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: widget.cartItem!.variation!
                                              .map((e) => Row(
                                                    children: [
                                                      Text(e.variationName!),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Text('-',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      e.variationPrice == 0
                                                          ? const Text(
                                                              'Free',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                color: Colors
                                                                    .black,
                                                                child: Text(
                                                                  '\$${e.variationPrice}',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ))
                                              .toList(),
                                        )
                                      : const SizedBox()
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
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _debouncer.run(() {
                                          // ref
                                          //     .read(DummyLogicProvider)
                                          //     .increaseQuantity(
                                          //       ref,
                                          //       widget.dish!.dishid!,
                                          //       widget.dish!.dish_price!,
                                          //     );
                                          ref
                                              .read(cartReopProvider)
                                              .increaseQuantityBasket(
                                                  cartid:
                                                      widget.cartItem!.cart_id!,
                                                  ref: ref,
                                                  price:
                                                      widget.dish!.dish_price);
                                        });
                                      },
                                      child: Container(
                                        height: widget.buttonIncDecHeight ?? 50,
                                        width: widget.buttonIncDecHeight ?? 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: const Icon(
                                          Icons.add,
                                          size: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    ref
                                        .read(cartProvider.notifier)
                                        .state[widget.quantityIndex!]
                                        .quantity
                                        .toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  // Text(
                                  //     style: const TextStyle(fontSize: 20),
                                  //     cartlistener
                                  //         .where((element) =>
                                  //             element.dish_id == dish.dishid)
                                  //         .length
                                  //         .toString()),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _debouncer.run(() async {
                                          //  final carid=cartlistener.firstWhere((element) => element.cart_id)

                                          await ref
                                              .read(cartReopProvider)
                                              .decreaseQuantityBasket(
                                                  cartid:
                                                      widget.cartItem!.cart_id!,
                                                  ref: ref,
                                                  price: widget
                                                      .cartItem!.itemprice!);
                                        });
                                      },
                                      child: Container(
                                        height: widget.buttonIncDecHeight ?? 50,
                                        width: widget.buttonIncDecWidth ?? 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
                                        child: Center(
                                            child:
                                                widget.cartItem!.quantity == 1
                                                    ? const Icon(
                                                        Icons.delete_outlined,
                                                        size: 24,
                                                        color: Colors.black,
                                                      )
                                                    : const Icon(
                                                        Icons.minimize_outlined,
                                                        size: 24,
                                                        color: Colors.black,
                                                      )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ]))),
    );
  }
}
