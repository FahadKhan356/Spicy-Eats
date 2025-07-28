import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

final variationListProvider = StateProvider<List<Variation>?>((ref) => null);
final freqDishesProvider = StateProvider<List<DishData>?>((ref) => []);

// ignore: must_be_immutable
class DishMenuVariation extends ConsumerStatefulWidget {
  static const String routename = '/DishMenuVariation';
  final DishData? dish;
  RestaurantModel? restaurantData;
  List<DishData>? dishes = [];
  List<VariattionTitleModel>? variationList = [];
  bool? isCart;
  bool isdishscreen = false;

  CartModel? cartDish;
  bool isbasket = false;
  List<int> dishesids = [];
  List<DishData>? freqdihses = [];
  int updateQuantity = 0;
  List<CartModel>? carts = [];

  DishMenuVariation({
    super.key,
    this.carts,
    required this.dish,
    this.cartDish,
    required this.isCart,
    required this.dishes,
    required this.restaurantData,
    required this.isdishscreen,
  });

  @override
  ConsumerState<DishMenuVariation> createState() => _DishMenuScreenState();
}

class _DishMenuScreenState extends ConsumerState<DishMenuVariation>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? _opacityanimation;
  Animation<Offset>? _offsetanimation;
  ScrollController? scrollController;
  bool? withvariation;
  bool isloader = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  Future<void> fetchVariations(int dishId) async {
    setState(() {
      isloader = true;
    });
    await ref
        .read(dishMenuRepoProvider)
        .fetchVariations(dishid: dishId, context: context)
        .then((value) {
      if (value != null) {
        setState(() {
          widget.variationList = value;
          if (widget.isCart!) {
            withvariation = true;
          } else {
            withvariation = false;
          }
        });
        print('with variation : $withvariation!');
      }
    });

    widget.freqdihses = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
          freqid: widget.dish?.frequentlyid,
          ref: ref,
          // dishes: widget.dishes!,
        );
    if (widget.freqdihses != null) {
      ref.read(freqDishesProvider.notifier).state = null;
    }

/* here we are matching if we are coming from cart to again dish menu variation screen then
 we are giving cart model's Variation list to the variationListProvider so can we show the same choosen variation
  that we chose earlier for the same order  */

    if (widget.isCart == true) {
      ref.read(variationListProvider.notifier).state =
          widget.cartDish!.variation;
      print(widget.cartDish!.variation?.length);
      // ref.read(freqDishesProvider.notifier).state =
      //     widget.cartDish?.freqboughts;
      print(' freqboughts length${widget.cartDish!.freqboughts!.length}');
      // print(
      //     ' freqboughts provider${ref.read(freqDishesProvider.notifier).state?[1].dish_name}');
      for (int i = 0; i < widget.carts!.length; i++) {
        widget.freqdihses!.removeWhere(
            (element) => element.dishid == widget.carts![i].dish_id);
      }
    }

    widget.updateQuantity = widget.cartDish!.quantity;
    setState(() {
      isloader = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController!.dispose();
    animationController!.dispose();
  }

  Future<void> naviagating() async {
    await Navigator.pushNamed(context, RestaurantMenuScreen.routename,
        arguments: ref.read(restaurantProvider.notifier).state);
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animationController!, curve: Curves.easeOut));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut));

    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController!.addListener(() {
      if (scrollController!.hasClients && scrollController!.offset > 50) {
        animationController!.forward();
      } else {
        animationController!.reverse();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(freqDishesProvider.notifier).state = null;
      fetchVariations(widget.dish!.dishid!);
      ref.read(variationListProvider.notifier).state = null;

      // setState(() {
      //   isloader = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);
    var quantity = ref.watch(quantityPrvider);

    var freqDish = ref.watch(freqDishesProvider);

    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Skeletonizer(
            enabled: isloader,
            enableSwitchAnimation: true,
            child: Stack(
              children: [
                // if (isloader)
                //   const Center(child: CircularProgressIndicator())
                // else
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      title: AnimatedBuilder(
                          animation: animationController!,
                          builder: (context, child) {
                            return Transform.translate(
                                offset: _offsetanimation!.value,
                                child: Opacity(
                                    opacity: _opacityanimation!.value,
                                    child: const Text(
                                      'Variation',
                                      style: TextStyle(color: Colors.black),
                                    )));
                          }),
                      expandedHeight: 200,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          widget.dish!.dish_imageurl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  ' from Rs ${widget.dish!.dish_price}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                widget.isCart!
                                    ? const Text('dsadaddaaaaaaaaaaaaaa',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))
                                    : const SizedBox(),
                                Text(
                                  widget.dish!.dish_description!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.isdishscreen &&
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                                'dishes': widget
                                                                    .dishes,
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
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: widget.variationList!.length,
                            (context, titleVariationindex) {
                      final titleVariation =
                          widget.variationList![titleVariationindex];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.black38),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        titleVariation.variationTitle
                                            .toString(),
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          color: titleVariation.isRequired!
                                              ? Colors.red
                                              : Colors.green,
                                          child: titleVariation.isRequired!
                                              ? const Text(
                                                  'Required',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                )
                                              : const Text(
                                                  'optional',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87),
                                                ),
                                        ),
                                      ),
                                    ]),
                                Text(
                                  titleVariation.subtitle.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                ...titleVariation.variations!.map((variation) {
                                  final variationlist =
                                      ref.watch(variationListProvider) ?? [];
                                  final isselected = variationlist
                                      .any((v) => v.id == variation.id);

                                  return CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                    title: variation.variationPrice! > 0
                                        ? Row(
                                            children: [
                                              Text(
                                                  ("${variation.variationName})")),
                                              Text(
                                                  " (\$${variation.variationPrice})"),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                  ("${variation.variationName}")),
                                              const Text(" Free")
                                            ],
                                          ),
                                    value: isselected, //isSelected,
                                    onChanged: (value) {
                                      final updatedList =
                                          List<Variation>.from(variationlist);
                                      if (value == true) {
                                        if (titleVariation.maxSeleted == null ||
                                            updatedList
                                                    .where((v) =>
                                                        v.variation_id ==
                                                        titleVariation.id)
                                                    .length <
                                                titleVariation.maxSeleted!) {
                                          updatedList.add(
                                            Variation(
                                              id: variation.id,
                                              variationName:
                                                  variation.variationName,
                                              variationPrice:
                                                  variation.variationPrice,
                                              variation_id:
                                                  variation.variation_id,
                                              selected: true,
                                            ),
                                          );
                                          if (titleVariation.isRequired!) {
                                            withvariation = true;
                                          }
                                        } else {
                                          if (scaffoldMessengerKey
                                                  .currentState !=
                                              null) {
                                            scaffoldMessengerKey.currentState!
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                'you can only select upto ${titleVariation.maxSeleted} options',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              margin: const EdgeInsets.only(
                                                bottom:
                                                    100, // Adjust this value to keep the SnackBar above the bottom UI
                                                left: 20,
                                                right: 20,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor: Colors.black,
                                            ));
                                          }
                                        }
                                      } else if (titleVariation.isRequired!) {
                                        updatedList.removeWhere(
                                            (v) => v.id == variation.id);
                                        withvariation = false;
                                      } else {
                                        updatedList.removeWhere(
                                            (v) => v.id == variation.id);
                                      }

                                      ref
                                          .read(variationListProvider.notifier)
                                          .state = updatedList;
                                    },
                                  );
                                }),
                              ],
                            )),
                      );
                    })),
                    const SliverToBoxAdapter(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        'Frequently Bought Together',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    )),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                      ),
                    ),
                    widget.freqdihses != null
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.freqdihses!.length,
                                  itemBuilder: (context, index) =>
                                      Image.network(widget
                                          .freqdihses![index].dish_imageurl!)),
                            ),
                          )
                        : SliverToBoxAdapter(),
                  ],
                ),
                (isloader == false &&
                        widget.variationList != null &&
                        widget.variationList!.isNotEmpty &&
                        widget.variationList!.indexWhere((element) =>
                                element.dishid == widget.dish!.dishid!) !=
                            -1)
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 10, sigmaY: 10), // blur effect
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 10)
                                ],
                              ),
                              height: 80,
                              width: double.maxFinite,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _debouncer.run(() {
                                                print(
                                                    'in the quantity provider');
                                                if (quantity > 0 &&
                                                    widget.isCart == false) {
                                                  ref
                                                      .read(quantityPrvider
                                                          .notifier)
                                                      .state++;
                                                } else if (widget.isCart ==
                                                    true) {
                                                  print(
                                                      'before in the just quantity $quantity');
                                                  setState(() {
                                                    widget.updateQuantity++;
                                                  });
                                                  print(
                                                      'after in the just quantity $quantity');
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: withvariation!
                                                      ? Colors.black
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: withvariation!
                                                    ? Colors.white
                                                    : Colors.black12,
                                              ),
                                            )),
                                        const SizedBox(width: 5),
                                        AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          transitionBuilder:
                                              ((child, animation) =>
                                                  ScaleTransition(
                                                    scale: animation,
                                                    child: child,
                                                  )),
                                          child: widget.isCart!
                                              ? Text(
                                                  key: ValueKey<int>(
                                                      widget.updateQuantity),
                                                  widget.updateQuantity
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: withvariation!
                                                        ? Colors.black
                                                        : Colors.black12,
                                                  ),
                                                )
                                              : Text(
                                                  key: ValueKey<int>(quantity),
                                                  quantity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: withvariation!
                                                        ? Colors.black
                                                        : Colors.black12,
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            _debouncer.run(() {
                                              print('in the quantity provider');
                                              if (quantity > 0 &&
                                                  widget.isCart == false) {
                                                ref
                                                    .read(quantityPrvider
                                                        .notifier)
                                                    .state--;
                                              } else if (widget.updateQuantity >
                                                      0 &&
                                                  widget.isCart == true) {
                                                print(
                                                    'before in the just quantity $quantity');
                                                setState(() {
                                                  widget.updateQuantity--;
                                                });
                                                print(
                                                    'after in the just quantity $quantity');
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: withvariation!
                                                  ? Colors.black
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.minimize_outlined,
                                              size: 20,
                                              color: withvariation!
                                                  ? Colors.white
                                                  : Colors.black12,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Builder(builder: (context) {
                                      return SizedBox(
                                        height: 50,
                                        width: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: withvariation!
                                                  ? Colors.black
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          onPressed: quantity > 0 &&
                                                  withvariation!
                                              ? () async {
                                                  _debouncer.run(() async {
                                                    setState(() {
                                                      isloader = true;
                                                    });

                                                    if (withvariation! &&
                                                        widget.isCart == true &&
                                                        widget.updateQuantity >
                                                            0) {
                                                      await ref
                                                          .read(
                                                              cartReopProvider)
                                                          .updateCart(
                                                              ref,
                                                              widget.dish!
                                                                  .dishid!,
                                                              widget.dish!
                                                                  .dish_price!,
                                                              ref
                                                                  .read(
                                                                    variationListProvider
                                                                        .notifier,
                                                                  )
                                                                  .state,
                                                              widget
                                                                  .updateQuantity);
                                                    } else if (withvariation! &&
                                                        widget.isCart ==
                                                            false &&
                                                        quantity > 0) {
                                                      await ref.read(cartReopProvider).addToCart(
                                                          widget
                                                              .dish!.dish_price!
                                                              .toDouble(),
                                                          widget
                                                              .dish!.dish_name,
                                                          widget.dish!
                                                              .dish_description,
                                                          ref,
                                                          supabaseClient.auth
                                                              .currentUser!.id,
                                                          widget.dish!.dishid!,
                                                          widget
                                                              .dish!.dish_price!
                                                              .toDouble(),
                                                          widget.dish!
                                                              .dish_discount,
                                                          widget.dish!
                                                              .dish_imageurl!,
                                                          ref
                                                              .read(
                                                                  variationListProvider
                                                                      .notifier)
                                                              .state,
                                                          true,
                                                          quantity,
                                                          ref
                                                              .read(
                                                                  freqDishesProvider
                                                                      .notifier)
                                                              .state);

                                                      ref
                                                          .read(quantityPrvider
                                                              .notifier)
                                                          .state = 1;
                                                    } else if (widget.isCart ==
                                                            true &&
                                                        withvariation == true &&
                                                        widget.updateQuantity ==
                                                            0) {
                                                      ref
                                                          .read(
                                                              cartReopProvider)
                                                          .removeItemFromBasket(
                                                              cartid: widget
                                                                  .cartDish!
                                                                  .cart_id!,
                                                              ref: ref);
                                                    } else {
                                                      print("nothing");
                                                    }
                                                    // await ref
                                                    //     .read(DummyLogicProvider)
                                                    //     .addToCart(
                                                    //         widget.dish!.dish_price!
                                                    //             .toDouble(),
                                                    //         widget.dish!.dish_name,
                                                    //         widget.dish!
                                                    //             .dish_description,
                                                    //         ref,
                                                    //         supabaseClient
                                                    //             .auth.currentUser!.id,
                                                    //         widget.dish!.dishid!,
                                                    //         widget.dish!.dish_price!
                                                    //             .toDouble(),
                                                    //         widget
                                                    //             .dish!.dish_imageurl!,
                                                    //         ref
                                                    //             .read(
                                                    //                 variationListProvider
                                                    //                     .notifier)
                                                    //             .state,
                                                    //         true,
                                                    //         quantity);

                                                    // we using Add to cart again because if user selects frequently food items
                                                    // then we also have to add them into cart and and frequently items are also type of DishData objects
                                                    print(
                                                        ' before Frequently bought together dishes: $freqDish');
                                                    if (freqDish!.isNotEmpty) {
                                                      print(
                                                          ' after Frequently bought together dishes:${freqDish[0].dish_name}');
                                                      for (int i = 0;
                                                          i < freqDish.length;
                                                          i++) {
                                                        await ref
                                                            .read(
                                                                cartReopProvider)
                                                            .addToCart(
                                                                freqDish[i]
                                                                    .dish_price!
                                                                    .toDouble(),
                                                                freqDish[i]
                                                                    .dish_name,
                                                                freqDish[i]
                                                                    .dish_description,
                                                                ref,
                                                                supabaseClient
                                                                    .auth
                                                                    .currentUser!
                                                                    .id,
                                                                freqDish[i]
                                                                    .dishid!,
                                                                freqDish[i]
                                                                    .dish_price!
                                                                    .toDouble(),
                                                                freqDish[i]
                                                                    .dish_discount,
                                                                freqDish[i]
                                                                    .dish_imageurl!,
                                                                null,
                                                                true,
                                                                1,
                                                                null);
                                                      }
                                                    } else {
                                                      print(
                                                          'No frequently bought together dishes found.'); // Debug log
                                                    }
                                                    // if (mounted) {
                                                    //   Navigator.pushNamed(
                                                    //       context,
                                                    //       RestaurantMenuScreen
                                                    //           .routename,
                                                    //       arguments: ref
                                                    //           .read(restaurantProvider
                                                    //               .notifier)
                                                    //           .state);
                                                    // }
                                                    await naviagating();
                                                  });

                                                  setState(() {
                                                    isloader = false;
                                                  });
                                                }
                                              : () {
                                                  if (mounted &&
                                                      scaffoldMessengerKey
                                                              .currentState !=
                                                          null) {
                                                    scaffoldMessengerKey
                                                        .currentState!
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Please add at least 1 item'),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin: EdgeInsets.only(
                                                            bottom: 100,
                                                            left: 20,
                                                            right: 20),
                                                      ),
                                                    );
                                                  }
                                                },
                                          child: widget.isCart! &&
                                                  widget.updateQuantity == 0
                                              ? Text(
                                                  'Remove to Cart',
                                                  style: TextStyle(
                                                      color: withvariation!
                                                          ? Colors.white
                                                          : Colors.black12),
                                                )
                                              : widget.isCart!
                                                  ? Text(
                                                      'Update Cart',
                                                      style: TextStyle(
                                                          color: withvariation!
                                                              ? Colors.white
                                                              : Colors.black12),
                                                    )
                                                  : Text(
                                                      'Add to Cart',
                                                      style: TextStyle(
                                                          color: withvariation!
                                                              ? Colors.white
                                                              : Colors.black12),
                                                    ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
