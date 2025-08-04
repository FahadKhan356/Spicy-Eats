import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/controller/dish-menu_controller.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

final isloaderProvider = StateProvider<bool>((ref) => false);
var quantityPrvider = StateProvider<int>((ref) => 1);
var updatedQuantityProvider = StateProvider<int>((ref) => 1);
final freqnewListProvider = StateProvider<List<DishData>?>((ref) => null);

// ignore: must_be_immutable
class DishMenuScreen extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuScreen';
  final DishData? dish;
  bool isCart = false;
  Cartmodel? cartDish;
  bool isbasket = false;
  List<DishData>? freqList = [];
  RestaurantModel? restaurantData;

  bool? isdishscreen = false;

  DishMenuScreen({
    super.key,
    required this.dish,
    this.cartDish,
    required this.isCart,
    required this.isdishscreen,
    required this.restaurantData,
  });

  @override
  ConsumerState<DishMenuScreen> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuScreen>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  AnimationController? _animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;
  bool isExpanded = false;
  bool? withvariation;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<void> fetchInitialData() async {
    final list = await ref
        .read(dishMenuControllerProvider)
        .fetchfrequentlybought(freqId: widget.dish!.frequentlyid!, ref: ref);
    setState(() {
      widget.freqList = list;
    });

    setState(() {
      withvariation = false;
    });

    if (widget.isCart) {
      ref.read(updatedQuantityProvider.notifier).state =
          widget.cartDish!.quantity;
    }
    ref.read(quantityPrvider.notifier).state = 1;
    debugPrint('isCart ${widget.isCart}');

    ref.read(isloaderProvider.notifier).state = false;

    if (widget.isCart) {
      for (int i = 0; i < ref.watch(cartProvider).length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == ref.read(cartProvider)[i].dish_id);
      }
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
        _animationController!.forward();
      } else {
        _animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData();
      debugPrint('isCart ${widget.isCart}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(isloaderProvider);
    final screen = MediaQuery.of(context).size;
    final width = screen.width;
    final height = screen.height;
    final quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);

    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Skeletonizer(
        ignorePointers: true,
        ignoreContainers: true,
        enabled: loader,
        enableSwitchAnimation: true,
        child: Stack(children: [
          // Set the background using a Container
          Positioned(
            top: 0,
            bottom: height * 0.95,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://as1.ftcdn.net/v2/jpg/02/97/25/74/1000_F_297257450_rpYIu8IRfA8qd8Al2hL56CrjmH6PUD8B.jpg'))),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
            child: DraggableScrollableSheet(
              initialChildSize: 0.95,
              minChildSize: 0.5,
              maxChildSize: 1.0,
              builder: (context, scrollController) => Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        surfaceTintColor: Colors.white,
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
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        expandedHeight: height * 0.4,
                        pinned: true,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dish!.dish_name!,
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.dish!.dish_discount == null
                                          ? Text(
                                              'from Rs \$${widget.dish!.dish_price}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * 0.04,
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
                                                  'from Rs  \$${widget.dish!.dish_discount}/-',
                                                  style: TextStyle(
                                                      fontSize: width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '  \$${widget.dish!.dish_price}',
                                                  style: TextStyle(
                                                      color: Colors.redAccent,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationThickness: 2,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .solid,
                                                      decorationColor:
                                                          Colors.redAccent,
                                                      fontSize: width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      !widget.isCart
                                          ? Text(
                                              ' - Already in your cart',
                                              style: TextStyle(
                                                  color: Colors.orange[900],
                                                  fontSize: width * 0.04,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.dish!.dish_description!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  widget.isdishscreen! &&
                                          widget.cartDish?.name != null
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: width * 0.11,
                                                  width: double.maxFinite,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
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
                                                                    width *
                                                                        0.030,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            '${widget.cartDish!.name}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.030,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                                  .read(dishesListProvider
                                                                      .notifier)
                                                                  .state,
                                                              'restdata': ref
                                                                  .read(restaurantProvider
                                                                      .notifier)
                                                                  .state
                                                            }),
                                                        child: Text(
                                                          'Edit in cart',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.030,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  const Divider(
                                    thickness: 2,
                                    color: Colors.black12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      'Frequently Bought Together',
                                      style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      widget.freqList != null && widget.freqList!.isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Freqdisheslist(
                                  screenSize: width,
                                  freqList: widget.freqList!))
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
                    child: customBottomNavBar(
                        ref,
                        width,
                        widget.isCart,
                        updatedQuantity,
                        context,
                        widget.dish!,
                        quantity,
                        widget.restaurantData!,
                        height,
                        _debouncer),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget customBottomNavBar(
    WidgetRef ref,
    double width,
    bool isCart,
    int updatedQuantity,
    context,
    DishData dish,
    int quantity,
    RestaurantModel restaurantData,
    double height,
    Debouncer debouncer) {
  return ClipRRect(
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
                        backgroundColor: Colors.orange[900],
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
                    onPressed: () {
                      ref.read(dishMenuRepoProvider).dishesCrud(
                          context: context,
                          ref: ref,
                          isCart: isCart,
                          updatedQuantity: updatedQuantity,
                          dish: dish,
                          quantity: quantity);

                      ref
                          .read(dishMenuRepoProvider)
                          .addAllFreqBoughtItems(ref: ref);
                      // }
                      Navigator.pushNamed(
                        context,
                        RestaurantMenuScreen.routename,
                        arguments: restaurantData,
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: double.maxFinite,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.yellow.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ],
                    color: Colors.orange[900],
                    borderRadius: BorderRadius.circular((width * 0.30) / 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        debugPrint('height $height width $width');
                        ref
                            .read(dishMenuControllerProvider)
                            .increaseItemQuantity(
                              isCart,
                              debouncer,
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
                        ref
                            .read(dishMenuControllerProvider)
                            .decreaseItemQuantity(
                              isCart,
                              debouncer,
                              ref,
                            );
                      },
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
