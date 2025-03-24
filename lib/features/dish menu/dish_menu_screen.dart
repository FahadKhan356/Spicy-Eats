import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

var quantityPrvider = StateProvider<int>((ref) => 1);
final variationListProvider = StateProvider<List<Variation>?>((ref) => null);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  List<VariattionTitleModel>? variationList = [];
  bool isCart = false;
  CartModelNew? cartDish;
  bool isbasket = false;
  List<DishData>? freqList = [];
  int updatedquantity = 0;
  bool? isdishscreen = false;

  DishMenuScreen(
      {super.key,
      required this.dish,
      this.cartDish,
      required this.isCart,
      required this.isdishscreen});

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  ScrollController? _scrollController;
  AnimationController? _animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;

  bool isExpanded = false;

  bool? withvariation;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  Future<void> fetchfrequentlybought() async {
    setState(() {
      isloading = true;
    });
    ref.read(freqDishesProvider.notifier).state = null;
    if (widget.dish?.frequentlyid != null) {
      widget.freqList = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
            freqid: widget.dish!.frequentlyid!,
            ref: ref,
          );
      print("${widget.freqList!.length} list of freq");

      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.bounceOut));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController!, curve: Curves.bounceOut));
    _scrollController!.addListener(() {
      if (_scrollController!.hasClients && _scrollController!.offset > 50) {
        print('${_scrollController!.offset}');
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        withvariation = false;
      });
      fetchfrequentlybought();
      if (widget.isCart) {
        widget.updatedquantity = widget.cartDish!.quantity;
      }
      ref.read(quantityPrvider.notifier).state = 1;
    });
  }

  Timer? _colapsetimer;
  void startTimer() {
    _colapsetimer!.cancel();
    _colapsetimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isExpanded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final quantity = ref.watch(quantityPrvider);

    final totalquantity = ref
        .read(DummyLogicProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Skeletonizer(
        enabled: isloading,
        enableSwitchAnimation: true,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  title: AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: _offsetanimation!.value,
                        child: Opacity(
                          opacity: _opacityanimation!.value,
                          child: child, // ✅ Pass child here
                        ),
                      );
                    },
                    child: const Text(
                      "Dish screen",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  // AnimatedBuilder(
                  //   animation: _animationController!,
                  //   builder: (context, child) =>
                  //       Transform.translate(offset: _offsetanimation!.value),
                  //   child: Opacity(
                  //     opacity: _opacityanimation!.value,
                  //     child: const Text(
                  //       "Dish screen",
                  //       style: TextStyle(color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      widget.dish!.dish_imageurl!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.dish!.dish_name!,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                widget.dish!.dish_discount == null
                                    ? Text(
                                        ' from Rs ${widget.dish!.dish_price}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                widget.dish!.dish_discount != null
                                    ? Row(
                                        children: [
                                          Text(
                                            ' from Rs ${widget.dish!.dish_discount}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '  ${widget.dish!.dish_price}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationThickness: 2,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                decorationColor: Colors.red,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            Text(
                              widget.dish!.dish_description!,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300),
                            ),
                            widget.isdishscreen! &&
                                    widget.cartDish!.name != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Already in your cart'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          height: 50,
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black38),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('${totalquantity}x'),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      '${widget.cartDish!.name}'),
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          BasketScreen
                                                              .routename,
                                                          arguments: {
                                                            'dishes': ref
                                                                .read(dishesListProvider
                                                                    .notifier)
                                                                .state,
                                                            'restdata': ref
                                                                .read(restaurantProvider
                                                                    .notifier)
                                                                .state
                                                          }),
                                                  child: const Text(
                                                      'Edit in cart')),
                                            ],
                                          )),
                                    ],
                                  )
                                : const SizedBox(),
                          ]),
                    ),
                  ),
                ),
                widget.freqList != null
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: widget.freqList!.length,
                            (context, index) {
                          final freqdish = widget.freqList![index];
                          final freqdishes =
                              ref.watch(freqDishesProvider) ?? [];
                          final selected = freqdishes.any(
                            (element) => element.dishid == freqdish.dishid,
                          );
                          return CheckboxListTile(
                              checkColor: Colors.white,
                              activeColor: Colors.black,
                              // title: Text(
                              //   freqdish.dish_name.toString(),
                              // ),
                              subtitle: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  // border: Border.all(
                                  //     width: 1, color: Colors.black38),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        freqdish.dish_imageurl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            freqdish.dish_name.toString(),
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          freqdish.dish_discount == null
                                              ? Text(
                                                  '\$${freqdish.dish_price}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    // decoration: TextDecoration
                                                    //     .lineThrough,
                                                    // decorationColor: Colors.red,
                                                    // decorationThickness: 2,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          freqdish.dish_discount != null
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      '\$${freqdish.dish_discount}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '\$${freqdish.dish_price}',
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              value: selected,
                              onChanged: (value) {
                                final newUpdatedList =
                                    List<DishData>.from(freqdishes);
                                if (value == true) {
                                  newUpdatedList.add(DishData(
                                    isVariation: false,
                                    dishid: freqdish.dishid,
                                    dish_description: freqdish.dish_description,
                                    dish_price: freqdish.dish_price,
                                    dish_discount: freqdish.dish_discount,
                                    dish_imageurl: freqdish.dish_imageurl,
                                    dish_name: freqdish.dish_name,
                                    dish_schedule_meal: '',
                                  ));
                                } else {
                                  newUpdatedList.removeWhere((element) =>
                                      element.dishid == freqdish.dishid);
                                }
                                ref.read(freqDishesProvider.notifier).state =
                                    newUpdatedList;
                              });
                        }),
                      )
                    : const SliverToBoxAdapter(
                        child: Text(
                        'asdsads',
                        style: TextStyle(color: Colors.black),
                      )),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, spreadRadius: 2, blurRadius: 3)
                    ],
                  ),
                  height: 80,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (widget.isCart) {
                                    _debouncer.run(() {
                                      setState(() {
                                        widget.updatedquantity++;
                                      });
                                    });
                                  } else {
                                    _debouncer.run(() {
                                      ref
                                          .read(quantityPrvider.notifier)
                                          .state++;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.add,
                                      size: 20, color: Colors.white),
                                )),
                            const SizedBox(width: 5),
                            widget.isCart
                                ? Text(
                                    widget.updatedquantity.toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )
                                : Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                if (widget.isCart) {
                                  _debouncer.run(() {
                                    setState(() {
                                      if (widget.updatedquantity > 0) {
                                        widget.updatedquantity--;
                                      }
                                    });
                                  });
                                } else {
                                  _debouncer.run(() {
                                    if (ref
                                            .read(quantityPrvider.notifier)
                                            .state >
                                        1) {
                                      ref
                                          .read(quantityPrvider.notifier)
                                          .state--;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.minimize_outlined,
                                  size: 20,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            child: widget.isCart && widget.updatedquantity > 0
                                ? const Text(
                                    'Update to cart',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : widget.isCart && widget.updatedquantity == 0
                                    ? const Text(
                                        'remove to cart',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        'Add to cart',
                                        style: TextStyle(color: Colors.white),
                                      ),
                            onPressed: () {
                              _debouncer.run(() async {
                                setState(() {
                                  isloading = true;
                                });
                                // final cartlistner =
                                //     ref.read(cartProvider.notifier).state;
                                if (widget.isCart &&
                                    widget.updatedquantity > 0) {
                                  await ref.read(DummyLogicProvider).updateCart(
                                      ref,
                                      widget.dish!.dishid!,
                                      widget.dish!.dish_price!,
                                      null,
                                      widget.updatedquantity);
                                } else if (widget.updatedquantity == 0 &&
                                    widget.isCart) {
                                  await ref
                                      .read(DummyLogicProvider)
                                      .removeitembasket(
                                          cartid: widget.cartDish!.cart_id!,
                                          ref: ref);
                                } else {
                                  await ref.read(DummyLogicProvider).addToCart(
                                      widget.dish!.dish_price!,
                                      widget.dish!.dish_name,
                                      widget.dish!.dish_description,
                                      ref,
                                      supabaseClient.auth.currentUser!.id,
                                      widget.dish!.dishid!,
                                      widget.dish!.dish_price!.toDouble(),
                                      widget.dish!.dish_discount,
                                      widget.dish!.dish_imageurl!,
                                      null,
                                      true,
                                      quantity,
                                      null);
                                  if (ref.read(freqDishesProvider) != null) {
                                    for (int i = 0;
                                        i <
                                            ref
                                                .read(freqDishesProvider)!
                                                .length;
                                        i++) {
                                      await ref
                                          .read(DummyLogicProvider)
                                          .addToCart(
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dish_price!,
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dish_name,
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dish_description,
                                              ref,
                                              supabaseClient
                                                  .auth.currentUser!.id,
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dishid!,
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dish_price!,
                                              widget.dish!.dish_discount,
                                              ref
                                                  .read(freqDishesProvider
                                                      .notifier)
                                                  .state![i]
                                                  .dish_imageurl!,
                                              null,
                                              false,
                                              1,
                                              null);
                                    }
                                  }
                                }
                              });
                              Navigator.pushNamed(
                                context,
                                RestaurantMenuScreen.routename,
                                arguments:
                                    ref.read(restaurantProvider.notifier).state,
                              );
                              setState(() {
                                isloading = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
