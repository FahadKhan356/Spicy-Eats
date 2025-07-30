import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/controller/dish-menu_controller.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

var quantityPrvider = StateProvider<int>((ref) => 1);
var updatedQuantityProvider = StateProvider<int>((ref) => 1);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  bool isCart = false;
  Cartmodel? cartDish;
  bool isbasket = false;
  List<DishData>? freqList = [];

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
    final screen = MediaQuery.of(context).size;
    final width = screen.width;
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
                  expandedHeight: 250,
                  // pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.dish!.dish_imageurl!,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: width * 0.11,
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 2,
                                                    color: Color.fromRGBO(
                                                        230, 81, 0, 1),
                                                    blurRadius: 2)
                                              ],
                                              color: Colors.orange[100],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.14),
                                              // border: Border.all(
                                              //   style: BorderStyle.solid,
                                              //   width: 1.5,
                                              //   color: const Color.fromRGBO(
                                              //       230, 81, 0, 1),
                                              // ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${totalquantity}x',
                                                      style: TextStyle(
                                                          fontSize:
                                                              width * 0.025,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      '${widget.cartDish!.name}',
                                                      style: TextStyle(
                                                          fontSize:
                                                              width * 0.025,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                                                            .read(
                                                                dishesListProvider
                                                                    .notifier)
                                                            .state,
                                                        'restdata': ref
                                                            .read(
                                                                restaurantProvider
                                                                    .notifier)
                                                            .state
                                                      }),
                                                  child: Text(
                                                    'Edit in cart',
                                                    style: TextStyle(
                                                        fontSize: width * 0.025,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ]),
                    ),
                  ),
                ),
                widget.freqList != null && widget.freqList!.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: Freqdisheslist(
                            screenSize: width, freqList: widget.freqList!))
                    : const SliverToBoxAdapter(
                        child: SizedBox(),
                      ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Container(
                    height: width * 0.1,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color.fromRGBO(230, 81, 0, 1),
                        Color.fromRGBO(230, 81, 0, 1),
                      ],
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                                    backgroundColor: Colors.orange[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          width * 0.35 / 2),
                                    )),
                                child: widget.isCart && updatedQuantity > 0
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Update to cart',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.028),
                                        ),
                                      )
                                    : widget.isCart && updatedQuantity < 1
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'remove to cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.028),
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Add to cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.028),
                                            ),
                                          ),
                                onPressed: () {
                                  if (widget.isCart && updatedQuantity > 0) {
                                    ref.read(cartReopProvider).updateCartItems(
                                        dishId: widget.dish!.dishid!,
                                        ref: ref,
                                        price: widget.dish!.dish_price!,
                                        newQuantity: updatedQuantity,
                                        newVariations: []);

                                    debugPrint(
                                        "inside : Widget.updatedquanity > 0 ?: ${updatedQuantity}");
                                  } else if (updatedQuantity < 1 &&
                                      widget.isCart) {
                                    ref.read(cartReopProvider).deleteCartItem(
                                        dishId: widget.dish!.dishid!, ref: ref);
                                    debugPrint(
                                        " inside : updatedquanity < 1 && iscart true?:: updatedquanity=> ${updatedQuantity} isCart=> ${widget.isCart} : $updatedQuantity");
                                  } else {
                                    ref.read(cartReopProvider).addCartItem(
                                        itemprice: widget.dish!.dish_price!,
                                        name: widget.dish!.dish_name,
                                        description:
                                            widget.dish!.dish_description,
                                        ref: ref,
                                        userId:
                                            supabaseClient.auth.currentUser!.id,
                                        dishId: widget.dish!.dishid!,
                                        discountprice:
                                            widget.dish!.dish_discount ?? 0,
                                        price: widget.dish!.dish_price,
                                        image: widget.dish!.dish_imageurl!,
                                        variations: null,
                                        isdishScreen: false,
                                        quantity: quantity,
                                        freqboughts: null);
                                    debugPrint(
                                        " else add to cart quantiry : $quantity");
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: double.maxFinite,
                              // width: width * 0.25,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.yellow.withOpacity(0.6),
                                        spreadRadius: 1,
                                        blurRadius: 10)
                                  ],
                                  color: Colors.orange[900],
                                  borderRadius: BorderRadius.circular(
                                      (width * 0.30) / 2)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(dishMenuControllerProvider)
                                          .increaseItemQuantity(
                                            widget.isCart,
                                            _debouncer,
                                            ref,
                                          );
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: width * 0.045,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  widget.isCart
                                      ? Text(
                                          // updatedQuantity.toString(),
                                          ref
                                              .read(updatedQuantityProvider
                                                  .notifier)
                                              .state
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.040,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.040,
                                              color: Colors.white),
                                        ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(dishMenuControllerProvider)
                                          .decreaseItemQuantity(
                                            widget.isCart,
                                            _debouncer,
                                            ref,
                                          );
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: width * 0.045,
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
                ))
          ],
        ),
      ),
    );
  }
}
