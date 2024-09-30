import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

final quantityProvider = StateProvider<List<ItemQuantity>>((ref) => []);
var showAddProvider = StateProvider<bool>((ref) => false);

class RestaurantMenu extends ConsumerStatefulWidget {
  static const String routename = "/restaurant-menu";
  final RestaurantData? restaurant;
  final List<DishData>? dishData;

  const RestaurantMenu(
      {super.key, required this.restaurant, required this.dishData});

  @override
  ConsumerState<RestaurantMenu> createState() => _RestaurantMenuState();
}

List<ItemQuantity> uniqueDish = [];

class _RestaurantMenuState extends ConsumerState<RestaurantMenu>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // List<ItemQuantity>? dishIds = [];
    // for (int i = 0; i < widget.dishData!.length; i++) {
    //   ItemQuantity itemQuantity = ItemQuantity(
    //     id: widget.dishData![i].dishid!,
    //   );
    //   dishIds.add(itemQuantity);
    //   uniqueDish = dishIds;
    // }
    super.initState();
    for (int i = 0; i < widget.dishData!.length; i++) {
      ref
          .read(quantityProvider.notifier)
          .state
          .add(ItemQuantity(id: widget.dishData![i].dishid!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.network(
                  widget.restaurant!.restaurantImageUrl!,
                  width: double.maxFinite,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.white,
                        child: Center(
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                    )),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.restaurant!.restaurantName!,
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\ ${widget.restaurant!.ratings}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.star,
                        size: 22,
                        color: Colors.amber,
                      ),
                      Text(
                        "- ${widget.restaurant!.address}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: ref
                      .read(homeControllerProvider)
                      .fetchDishes(restuid: ref.read(rest_ui_Provider)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No dishes'),
                      );
                    } else if (snapshot.hasError) {
                      mysnackbar(
                          context: context, text: snapshot.error.toString());
                      return const Center(child: Text('An error occurred'));
                    } else if (snapshot.hasData &&
                        snapshot.data!.isNotEmpty &&
                        snapshot.data != null) {
                      final dishes = snapshot.data;

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: dishes!.length,
                          itemBuilder: (context, index) {
                            return Consumer(builder: (context, ref, child) {
                              final itemQuantity = ref
                                  .watch(quantityProvider)
                                  .firstWhere((item) =>
                                      item.id == dishes[index].dishid);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    index == 0
                                        ? const Text(
                                            "Menu",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const SizedBox(),
                                    index != 0
                                        ? const Divider(
                                            height: 4,
                                            thickness: 4,
                                            color: Colors.black26,
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        widget.dishData![index].dish_imageurl !=
                                                    null &&
                                                widget.dishData![index]
                                                    .dish_imageurl!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  widget.dishData![index]
                                                      .dish_imageurl!,
                                                  fit: BoxFit.cover,
                                                  width: 120,
                                                  height: 120,
                                                ),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.dishData![index]
                                                    .dish_name!,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.dishData![index]
                                                    .dish_description!,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 20,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "\$ ${widget.dishData![index].dish_price}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeIn,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AnimatedOpacity(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    opacity:
                                                        itemQuantity.quantity >
                                                                0
                                                            ? 1.0
                                                            : 0.50,
                                                    child:
                                                        itemQuantity.quantity >
                                                                0
                                                            ? Row(
                                                                children: [
                                                                  QuantityButton(
                                                                    buttonradius:
                                                                        10,
                                                                    buttonheight:
                                                                        40,
                                                                    icon: Icons
                                                                        .remove,
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                    iconSize:
                                                                        30,
                                                                    bgcolor: Colors
                                                                        .black,
                                                                    onpress:
                                                                        () {
                                                                      int dishindex = ref
                                                                          .read(quantityProvider
                                                                              .notifier)
                                                                          .state
                                                                          .indexWhere((element) =>
                                                                              element.id ==
                                                                              widget.dishData![index].dishid);

                                                                      if (dishindex !=
                                                                          -1) {
                                                                        ref.read(quantityProvider.notifier).update(
                                                                            (state) {
                                                                          if (state[dishindex].quantity >
                                                                              0) {
                                                                            state[dishindex].quantity--;
                                                                          }
                                                                          return [
                                                                            ...state
                                                                          ];
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                  Consumer(
                                                                    builder:
                                                                        (context,
                                                                            ref,
                                                                            child) {
                                                                      final quantity = ref
                                                                          .watch(
                                                                              quantityProvider)
                                                                          .firstWhere((item) =>
                                                                              item.id ==
                                                                              widget.dishData![index].dishid)
                                                                          .quantity;
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          " $quantity",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                28,
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  QuantityButton(
                                                                    buttonradius:
                                                                        10,
                                                                    icon: Icons
                                                                        .add,
                                                                    iconColor:
                                                                        Colors
                                                                            .white,
                                                                    iconSize:
                                                                        30,
                                                                    bgcolor: Colors
                                                                        .black,
                                                                    buttonheight:
                                                                        40,
                                                                    onpress:
                                                                        () {
                                                                      final dishIndex = ref
                                                                          .read(quantityProvider
                                                                              .notifier)
                                                                          .state
                                                                          .indexWhere((item) =>
                                                                              item.id ==
                                                                              widget.dishData![index].dishid);
                                                                      if (dishIndex !=
                                                                          -1) {
                                                                        ref.read(quantityProvider.notifier).update(
                                                                            (state) {
                                                                          state[dishIndex]
                                                                              .quantity++;

                                                                          if (ref.read(quantityProvider.notifier).state[dishIndex].quantity >
                                                                              0) {
                                                                            ref.read(showAddProvider.notifier).state =
                                                                                true;
                                                                          }

                                                                          return [
                                                                            ...state
                                                                          ]; // return a new state
                                                                        });
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              )
                                                            : QuantityButton(
                                                                bgcolor: Colors
                                                                    .white,
                                                                buttonheight:
                                                                    40,
                                                                buttonradius:
                                                                    10,
                                                                icon:
                                                                    Icons.done,
                                                                iconColor:
                                                                    Colors.red,
                                                                iconSize: 30,
                                                                onpress: () {
                                                                  var dish = ref
                                                                      .watch(quantityProvider
                                                                          .notifier)
                                                                      .state
                                                                      .indexWhere((item) =>
                                                                          item.id ==
                                                                          widget
                                                                              .dishData![index]
                                                                              .dishid);

                                                                  ref
                                                                      .watch(quantityProvider
                                                                          .notifier)
                                                                      .update(
                                                                          (state) {
                                                                    state[dish]
                                                                        .quantity++;

                                                                    return [
                                                                      ...state
                                                                    ];
                                                                  });
                                                                  print(ref
                                                                      .watch(quantityProvider
                                                                          .notifier)
                                                                      .state[
                                                                          index]
                                                                      .quantity);
                                                                },
                                                              )),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                          });
                    } else {
                      // Handle the case where there is no data
                      return const Center(child: Text('No dishes available'));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
