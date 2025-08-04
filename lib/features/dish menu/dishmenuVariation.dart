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
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';
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
  List<DishData>? freqList;
  Cartmodel? cartDish;
  bool isbasket = false;
  List<int> dishesids = [];

  // int updateQuantity = 0;
  List<Cartmodel>? carts = [];

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

    widget.freqList = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
          freqid: widget.dish?.frequentlyid,
          ref: ref,
          // dishes: widget.dishes!,
        );
    // if (widget.freqList != null) {
    //   ref.read(freqDishesProvider.notifier).state = null;
    // }

/* here we are matching if we are coming from cart to again dish menu variation screen then
 we are giving cart model's Variation list to the variationListProvider so can we show the same choosen variation
  that we chose earlier for the same order  */

    if (widget.isCart == true) {
      ref.read(variationListProvider.notifier).state =
          widget.cartDish!.variation;
      print(widget.cartDish!.variation?.length);
      // ref.read(freqDishesProvider.notifier).state =
      //     widget.cartDish?.freqboughts;
      // print(' freqboughts length${widget.cartDish!.freqboughts!.length}');
      // print(
      //     ' freqboughts provider${ref.read(freqDishesProvider.notifier).state?[1].dish_name}');
      for (int i = 0; i < widget.carts!.length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == widget.carts![i].dish_id);
      }
    }

    // widget.updateQuantity = widget.cartDish!.quantity;
    setState(() {
      isloader = false;
    });
    debugPrint("  the incoming car dish quantity ${widget.cartDish!.quantity}");
    ref.read(updatedQuantityProvider.notifier).state =
        widget.cartDish!.quantity;
    debugPrint(
        "  updatedQuntity that stores card dish quaity ${ref.read(updatedQuantityProvider)}");
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
      fetchfrequentlybought;

      ref.read(quantityPrvider.notifier).state = 1;
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
    final width = MediaQuery.of(context).size.width;
    final dish = widget.dish;
    final userId = supabaseClient.auth.currentUser!.id;
    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);
    var quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);

    var freqDish = ref.watch(freqDishesProvider);
    final cartRepo = ref.watch(cartReopProvider);

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
                      expandedHeight: 300,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.dish!.dish_imageurl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                height: 50,
                                                width: double.maxFinite,
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
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
                                                                        0.032,
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
                                                                        0.032,
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
                                                                    'dishes': widget
                                                                        .dishes,
                                                                    'restdata': ref
                                                                        .read(restaurantProvider
                                                                            .notifier)
                                                                        .state
                                                                  }),
                                                          child: Text(
                                                            'Edit in cart',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.032,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ],
                                                  ),
                                                )),
                                          ),
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
                    widget.freqList != null
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
                (isloader == false &&
                        widget.variationList != null &&
                        widget.variationList!.isNotEmpty &&
                        widget.variationList!.indexWhere((element) =>
                                element.dishid == widget.dish!.dishid!) !=
                            -1)
                    ? Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            height: width * 0.13,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.35 / 2),
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
                                                      updatedQuantity > 0) {
                                                    ref
                                                        .read(cartReopProvider)
                                                        .updateCartItems(
                                                            dishId: widget
                                                                .dish!.dishid!,
                                                            ref: ref,
                                                            price: widget.dish!
                                                                .dish_price!,
                                                            newQuantity:
                                                                updatedQuantity,
                                                            newVariations: ref
                                                                .read(variationListProvider
                                                                    .notifier)
                                                                .state!);

                                                    debugPrint(
                                                        "inside : Widget.updatedquanity > 0 ?: ${updatedQuantity}");
                                                  } else if (withvariation! &&
                                                      widget.isCart == false &&
                                                      quantity > 0) {
                                                    ref
                                                        .read(cartReopProvider)
                                                        .addCartItem(
                                                            withVariation: true,
                                                            itemprice: widget
                                                                .dish!
                                                                .dish_price!,
                                                            name: widget.dish!
                                                                .dish_name,
                                                            description: widget
                                                                .dish!
                                                                .dish_description,
                                                            ref: ref,
                                                            userId:
                                                                supabaseClient
                                                                    .auth
                                                                    .currentUser!
                                                                    .id,
                                                            dishId: widget
                                                                .dish!.dishid!,
                                                            discountprice: widget
                                                                    .dish!
                                                                    .dish_discount ??
                                                                0,
                                                            price: widget.dish!
                                                                .dish_price,
                                                            image: widget.dish!
                                                                .dish_imageurl!,
                                                            variations:
                                                                // [],
                                                                ref
                                                                    .read(variationListProvider
                                                                        .notifier)
                                                                    .state,
                                                            isdishScreen: false,
                                                            quantity: quantity,
                                                            freqboughts: ref
                                                                .read(freqDishesProvider
                                                                    .notifier)
                                                                .state);
                                                    debugPrint(
                                                        " else add to cart quantiry : $quantity");
                                                  } else if (widget.isCart ==
                                                          true &&
                                                      withvariation == true &&
                                                      updatedQuantity == 0) {
                                                    ref
                                                        .read(cartReopProvider)
                                                        .deleteCartItem(
                                                            dishId: widget
                                                                .dish!.dishid!,
                                                            ref:
                                                                ref); // cartRepo.deleteCartItem(
                                                  } else {
                                                    print("nothing");
                                                  }

                                                  // we using Add to cart again because if user selects frequently food items
                                                  // then we also have to add them into cart and and frequently items are also type of DishData objects
                                                  print(
                                                      ' before Frequently bought together dishes: $freqDish');
                                                  if (freqDish != null &&
                                                      freqDish.isNotEmpty) {
                                                    print(
                                                        ' after Frequently bought together dishes:${freqDish[0].dish_name}');
                                                    for (int i = 0;
                                                        i < freqDish.length;
                                                        i++) {
                                                      cartRepo.addCartItem(
                                                        itemprice: freqDish[i]
                                                            .dish_price!
                                                            .toDouble(),
                                                        name: freqDish[i]
                                                            .dish_name,
                                                        description: freqDish[i]
                                                            .dish_description,
                                                        ref: ref,
                                                        userId: userId,
                                                        dishId:
                                                            freqDish[i].dishid!,
                                                        discountprice:
                                                            freqDish[i]
                                                                .dish_discount,
                                                        price: freqDish[i]
                                                            .dish_price,
                                                        image: freqDish[i]
                                                            .dish_imageurl!,
                                                        variations: ref
                                                            .read(
                                                                variationListProvider
                                                                    .notifier)
                                                            .state,
                                                        isdishScreen: true,
                                                        quantity: quantity,
                                                        freqboughts: ref
                                                            .read(
                                                                freqDishesProvider
                                                                    .notifier)
                                                            .state,
                                                      );
                                                    }
                                                  } else {
                                                    print(
                                                        'No frequently bought together dishes found.'); // Debug log
                                                  }

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
                                                      behavior: SnackBarBehavior
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
                                                updatedQuantity > 0
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Update to cart',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.028),
                                                ),
                                              )
                                            : widget.isCart! &&
                                                    updatedQuantity == 0
                                                ? Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'remove to cart',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              width * 0.028),
                                                    ),
                                                  )
                                                : Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Add to cart',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              width * 0.028),
                                                    ),
                                                  ),
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
                                                color: Colors.yellow
                                                    .withOpacity(0.6),
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
                                              _debouncer.run(() {
                                                print(
                                                    'in the quantity provider');
                                                if (widget.isCart == false) {
                                                  ref
                                                      .read(quantityPrvider
                                                          .notifier)
                                                      .state++;
                                                } else if (widget.isCart ==
                                                    true) {
                                                  print(
                                                      'before in the just quantity $quantity');
                                                  setState(() {
                                                    ref
                                                        .read(
                                                            updatedQuantityProvider
                                                                .notifier)
                                                        .state++;
                                                  });
                                                  print(
                                                      'after in the just quantity $quantity');
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: width * 0.045,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            transitionBuilder:
                                                ((child, animation) =>
                                                    ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                    )),
                                            child: widget.isCart!
                                                ? Text(
                                                    key: ValueKey<int>(
                                                        updatedQuantity),
                                                    updatedQuantity.toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: withvariation!
                                                          ? Colors.black
                                                          : Colors.black12,
                                                    ),
                                                  )
                                                : Text(
                                                    key:
                                                        ValueKey<int>(quantity),
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
                                          IconButton(
                                            onPressed: () {
                                              _debouncer.run(() {
                                                debugPrint(
                                                    'in the quantity provider');
                                                if (quantity > 0 &&
                                                    widget.isCart == false) {
                                                  ref
                                                      .read(quantityPrvider
                                                          .notifier)
                                                      .state--;
                                                } else if (updatedQuantity >
                                                        0 &&
                                                    widget.isCart == true) {
                                                  debugPrint(
                                                      'before in the just quantity $quantity');
                                                  // setState(() {
                                                  // widget.updateQuantity--;
                                                  // });
                                                  ref
                                                      .read(
                                                          updatedQuantityProvider
                                                              .notifier)
                                                      .state--;
                                                  debugPrint(
                                                      'after in the just quantity $quantity');
                                                }
                                              });
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
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
