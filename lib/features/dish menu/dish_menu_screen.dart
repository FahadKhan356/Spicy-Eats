import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Basket/controller/CartController.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/controller/dish-menu_controller.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

var quantityPrvider = StateProvider<int>((ref) => 1);
var updatedQuantityProvider = StateProvider<int>((ref) => 1);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  List<VariattionTitleModel>? variationList = [];
  bool isCart = false;
  CartModel? cartDish;
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
    final list = await ref
        .read(dishMenuControllerProvider)
        .fetchfrequentlybought(freqId: widget.dish!.frequentlyid!, ref: ref);
    setState(() {
      widget.freqList = list;
    });
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
        // print('${_scrollController!.offset}');
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        withvariation = false;
      });

      // fetchfrequentlybought();
      if (widget.isCart) {
        ref.read(updatedQuantityProvider.notifier).state =
            widget.cartDish!.quantity;
        widget.updatedquantity = widget.cartDish!.quantity;
        debugPrint("cart qunatity dish menu: ${widget.cartDish!.quantity}");
      }
      ref.read(quantityPrvider.notifier).state = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchfrequentlybought();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);

    final totalquantity = ref
        .read(cartReopProvider)
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
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      widget.dish!.dish_imageurl!,
                      fit: BoxFit.cover,
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
                widget.freqList != null && widget.freqList!.isNotEmpty
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
                                      child: freqdish.dish_imageurl != null
                                          ? Image.network(
                                              freqdish.dish_imageurl.toString(),
                                              fit: BoxFit.cover,
                                            )
                                          : const CircularProgressIndicator(),
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
                        child: SizedBox(),
                      ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter:
                        ImageFilter.blur(sigmaX: 10, sigmaY: 10), // blur effect
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2,
                              blurRadius: 3)
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
                                      ref
                                          .read(dishMenuControllerProvider)
                                          .increaseItemQuantity(
                                              widget.isCart, _debouncer, ref);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(Icons.add,
                                          size: 20, color: Colors.white),
                                    )),
                                const SizedBox(width: 5),
                                widget.isCart
                                    ? Text(
                                        // updatedQuantity.toString(),
                                        ref
                                            .read(updatedQuantityProvider
                                                .notifier)
                                            .state
                                            .toString(),
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
                                    ref
                                        .read(dishMenuControllerProvider)
                                        .decreaseItemQuantity(
                                          widget.isCart,
                                          _debouncer,
                                          ref,
                                        );
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
                                child: widget.isCart && updatedQuantity > 0
                                    ? const Text(
                                        'Update to cart',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : widget.isCart && updatedQuantity == 0
                                        ? const Text(
                                            'remove to cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : const Text(
                                            'Add to cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                onPressed: () {
                                  ref
                                      .read(cartControllerProvider)
                                      .itemAddUpdateRemoveCart(
                                          ref: ref,
                                          debouncer: _debouncer,
                                          refreshUI: (fn) => setState(() => ()),
                                          isLoading: isloading,
                                          isCart: widget.isCart,
                                          updatedquantity: updatedQuantity,
                                          dish: widget.dish!,
                                          cartDish: widget.cartDish!,
                                          quantity: quantity,
                                          context: context);

                                  debugPrint("quantiry : $quantity");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
