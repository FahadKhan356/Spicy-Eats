import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/features/dish%20menu/widget/customBottomBar.dart';
import 'package:spicy_eats/features/dish%20menu/widget/freqDishesList.dart';

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

  Future<void> initialDataLoad(int dishId) async {
    if (mounted) {
      await fetchVariations(dishId);
      await fetchfrequentlybought();
    }
    if (widget.isCart!) {
      for (int i = 0; i < ref.watch(cartProvider).length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == ref.read(cartProvider)[i].dish_id);
      }
    }
  }

  Future<void> fetchfrequentlybought() async {
    final list = await ref.read(dishMenuRepoProvider).fetchfrequentlybuy(
          freqid: widget.dish?.frequentlyid,
          ref: ref,
        );

    setState(() {
      widget.freqList = list;
    });
  }

  Future<void> fetchVariations(int dishId) async {
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
        );
    debugPrint(
        ' outside cartdish variation length${widget.cartDish?.variation?.length} and is cart ${widget.isCart}');
    if (widget.isCart == true) {
      debugPrint(
          'inside if cartdish variation length${widget.cartDish?.variation?.length}');
      ref.read(variationListProvider.notifier).state =
          widget.cartDish!.variation;

      // ref.read(freqDishesProvider.notifier).state =
      //     widget.cartDish?.freqboughts;
      // print(' freqboughts length${widget.cartDish!.freqboughts!.length}');
      // print(
      //     ' freqboughts provider${ref.read(freqDishesProvider.notifier).state?[1].dish_name}');
      for (int i = 0; i < widget.carts!.length; i++) {
        widget.freqList!.removeWhere(
            (element) => element.dishid == widget.carts![i].dish_id);
      }

      ref.read(updatedQuantityProvider.notifier).state =
          widget.cartDish!.quantity;
    } else {
      ref.read(variationListProvider.notifier).state = null;
    }
    //   ref.read(variationListProvider.notifier).state =
    //       widget.cartDish!.variation;
    //   print(widget.cartDish!.variation?.length);

    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController!.dispose();
    animationController?.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _offsetanimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animationController!, curve: Curves.easeOut));
    _opacityanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut));

    scrollController!.addListener(() {
      // if (_scrollController!.hasClients && _scrollController!.offset > 50) {
      if (!mounted) return;
      final offset =
          scrollController!.hasClients ? scrollController!.offset : 0.0;

      if (offset > 50) {
        animationController!.forward();
      } else {
        animationController!.reverse();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialDataLoad(widget.dish!.dishid!);
      ref.read(isloaderProvider.notifier).state = false;
      // fetchfrequentlybought;
      ref.read(quantityPrvider.notifier).state = 1;

      // fetchVariations(widget.dish!.dishid!);
      // ref.read(variationListProvider.notifier).state = null;

      // setState(() {
      //   isloader = false;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isloader = ref.watch(isloaderProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final totalquantity = ref
        .read(cartReopProvider)
        .getTotalQuantityofdish(ref, widget.dish!.dishid!);
    var quantity = ref.watch(quantityPrvider);
    final updatedQuantity = ref.watch(updatedQuantityProvider);

    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Skeletonizer(
            ignorePointers: true,
            ignoreContainers: true,
            enabled: isloader,
            enableSwitchAnimation: true,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: !isloader ? scrollController : null,
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
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )));
                          }),
                      expandedHeight: height * 0.4,
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
                                  style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    !widget.isCart!
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
                                  style: TextStyle(
                                      fontSize: width * 0.035,
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
                              color: Colors.orange[100],
                              // gradient: Gradient.linear(0, 9,  colors: [
                              //       Color.fromRGBO(255, 224, 178, 1),
                              //       Colors.black26
                              //     ]) ,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 2,
                                    color: Color.fromRGBO(230, 81, 0, 1),
                                    blurRadius: 2)
                              ],
                              // border:
                              // Border.all(width: 1, color: Colors.black38),
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
                                              totalvariation: 5,
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

                                      debugPrint(
                                          "new Variation list :      ${ref.read(variationListProvider.notifier).state}  ");
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
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.03,
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
                        child: customBottomBar(
                            false,
                            mounted,
                            scaffoldMessengerKey,
                            true,
                            withvariation!,
                            ref,
                            width,
                            widget.isCart!,
                            updatedQuantity,
                            context,
                            widget.dish!,
                            quantity,
                            widget.restaurantData!,
                            height,
                            _debouncer, onAction: () {
                          debugPrint(
                              ' variation check  ${ref.read(variationListProvider.notifier).state}');

                          ref.read(dishMenuRepoProvider).dishMenuCrud(
                              cart: widget.cartDish!,
                              // totalVaritionPrice: totalvariation,
                              variations: ref
                                  .read(variationListProvider.notifier)
                                  .state,
                              newFreqList:
                                  ref.read(freqnewListProvider.notifier).state,
                              ref: ref,
                              withvariation: withvariation!,
                              debouncer: _debouncer,
                              isCart: widget.isCart!,
                              updatedQuantity: updatedQuantity,
                              dish: widget.dish!,
                              quantity: quantity,
                              context: context);

                          ref
                              .read(dishMenuRepoProvider)
                              .addAllFreqBoughtItems(ref: ref);
                          debugPrint(
                              ' freq list check  ${ref.read(freqnewListProvider.notifier).state}');

                          Navigator.pushNamed(
                            context,
                            RestaurantMenuScreen.routename,
                            arguments: {
                              'restaurantData': widget.restaurantData,
                              'initTab': false,
                            },
                          );
                        }))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
