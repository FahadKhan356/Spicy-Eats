import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
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
  //List<DishData>? dishData;
  final String? rest_uid;

  RestaurantMenu(
      {super.key,
      required this.restaurant,
      //required this.dishData,
      required this.rest_uid});

  @override
  ConsumerState<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends ConsumerState<RestaurantMenu>
    with TickerProviderStateMixin {
  List<DishData>? dishesData;

  @override
  void initState() {
    super.initState();
    ref
        .read(homeControllerProvider)
        .fetchDishes(restuid: widget.rest_uid)
        .then((dishes) {
      if (dishes != null) {
        setState(() {
          dishesData = dishes;
          print('dishesData check: ${dishesData!.length}');
        });

        // Schedule the update of quantityProvider after the current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          List<ItemQuantity> newQuantityList = [];
          for (int i = 0; i < dishesData!.length; i++) {
            newQuantityList.add(ItemQuantity(id: dishesData![i].dishid!));
            print('checking given dishData :: ${dishesData![i].dishid}');
          }

          //Update quantityProvider state
          ref
              .read(quantityProvider.notifier)
              .update((state) => newQuantityList);
        });
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   ref
  //       .read(homeControllerProvider)
  //       .fetchDishes(restuid: widget.rest_uid)
  //       .then((dishes) {
  //     if (dishes != null) {
  //       setState(() {
  //         dishesData = dishes;
  //         print('dishesData check: ${dishesData!.length}');
  //       });
  //     }
  //   });
  //   // for (int i = 0; i < dishesData!.length; i++) {
  //   //   ref
  //   //       .read(quantityProvider.notifier)
  //   //       .state
  //   //       .add(ItemQuantity(id: dishesData![i].dishid!));

  //   //   print('checking given dishData :: ${dishesData![i].dishid}');
  //   //   print(
  //   //       'checking given quantityProvider :: ${ref.read(quantityProvider)[i].id}');
  //   // }

  //   // List<ItemQuantity>? dishIds = [];
  //   // for (int i = 0; i < widget.dishData!.length; i++) {
  //   //   ItemQuantity itemQuantity = ItemQuantity(
  //   //     id: widget.dishData![i].dishid!,
  //   //   );
  //   //   dishIds.add(itemQuantity);
  //   //   uniqueDish = dishIds;
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Image.network(
                    widget.restaurant!.restaurantImageUrl!,
                    width: double.maxFinite,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
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
                Positioned(
                  bottom: 0,
                  left: (size.width / 2) - 50,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 6),
                        borderRadius: BorderRadius.circular(50)),
                    child: widget.restaurant!.restaurantLogoImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                                fit: BoxFit.cover,
                                widget.restaurant!.restaurantLogoImageUrl!),
                          )
                        : const SizedBox(),
                  ),
                )
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.restaurant!.restaurantName!,
                      style: TextStyle(
                        fontSize: size.width * 0.06,
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
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.star,
                        size: 22,
                        color: Colors.amber,
                      ),
                      Expanded(
                        child: Text(
                          "- ${widget.restaurant!.address}",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
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
                      .fetchDishes(restuid: widget.rest_uid!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // else if (snapshot.data != null) {
                    //   return const Center(
                    //     child: Text('No dishes'),
                    //   );
                    else if (snapshot.hasError) {
                      mysnackbar(
                          context: context, text: snapshot.error.toString());
                      return const Center(child: Text('An error occurred'));
                    } else if (snapshot.hasData &&
                        snapshot.data!.isNotEmpty &&
                        snapshot.data != null) {
                      final dishes = snapshot.data;

                      return snapshot.data != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dishes!.length,
                              itemBuilder: (context, index) {
                                return Consumer(builder: (context, ref, child) {
                                  // final itemQuantity = ref
                                  //     .watch(quantityProvider)
                                  //     .firstWhere((item) =>
                                  //         item.id == dishes[index].dishid);
                                  final itemQuantity =
                                      ref.watch(quantityProvider).firstWhere(
                                            (item) =>
                                                item.id == dishes[index].dishid,
                                            orElse: () => ItemQuantity(
                                                id: dishes[index].dishid!,
                                                quantity:
                                                    0), // Provide a default value
                                          );

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(ref
                                        //     .read(quantityProvider)
                                        //     .length
                                        //     .toString()),
                                        index == 0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    height: 5,
                                                    width: size.width / 3,
                                                    color: Colors.black12,
                                                  ),
                                                  const Text(
                                                    "Menu",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    height: 5,
                                                    width: size.width / 3,
                                                    color: Colors.black12,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        index != 0
                                            ? Divider(
                                                height: 4,
                                                thickness: 4,
                                                color: Colors.grey[100],
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            // if (dishes[index]
                                            //             .dish_imageurl ==
                                            //         null &&
                                            //     dishes[index]
                                            //         .dish_imageurl!
                                            //         .isEmpty)
                                            //   const SizedBox(),
                                            // if (dishesData![index]
                                            //             .dish_imageurl !=
                                            //         null &&
                                            //     dishesData![index]
                                            //         .dish_imageurl!
                                            //         .isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                dishes[index].dish_imageurl!,
                                                fit: BoxFit.cover,
                                                width: size.width * 0.25,
                                                height: size.width * 0.25,
                                              ),
                                            ),
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
                                                    dishes[index].dish_name!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * 0.04,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    dishes[index]
                                                        .dish_description!,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize:
                                                            size.width * 0.04,
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "\$ ${dishes[index].dish_price}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * 0.04,
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
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.bounceInOut,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AnimatedOpacity(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        opacity: itemQuantity
                                                                    .quantity >
                                                                0
                                                            ? 1.0
                                                            : 0.50,
                                                        child: itemQuantity
                                                                    .quantity >
                                                                0
                                                            ? Container(
                                                                // width:
                                                                //     size.width *
                                                                //         0.09,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                            .grey[
                                                                        200]),
                                                                child: Column(
                                                                  children: [
                                                                    QuantityButton(
                                                                      radiustopleft:
                                                                          10,
                                                                      radiustopright:
                                                                          10,
                                                                      // buttonradius:
                                                                      //     10,
                                                                      buttonheight:
                                                                          size.width *
                                                                              0.09,
                                                                      buttonwidth:
                                                                          size.width *
                                                                              0.09,
                                                                      icon: Icons
                                                                          .remove,
                                                                      iconColor:
                                                                          Colors
                                                                              .white,
                                                                      iconSize:
                                                                          size.width *
                                                                              0.055,
                                                                      bgcolor:
                                                                          Colors
                                                                              .black,
                                                                      onpress:
                                                                          () {
                                                                        int dishindex = ref
                                                                            .read(quantityProvider
                                                                                .notifier)
                                                                            .state
                                                                            .indexWhere((element) =>
                                                                                element.id ==
                                                                                dishesData![index].dishid);

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
                                                                      builder: (context,
                                                                          ref,
                                                                          child) {
                                                                        final quantity = ref
                                                                            .watch(
                                                                                quantityProvider)
                                                                            .firstWhere((item) =>
                                                                                item.id ==
                                                                                dishes[index].dishid)
                                                                            .quantity;
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            " $quantity",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: size.width * 0.05,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    QuantityButton(
                                                                      radiusbottomleft:
                                                                          10,
                                                                      radiusbottomright:
                                                                          10,
                                                                      // radiustopleft:
                                                                      //     10,
                                                                      // radiustopright:
                                                                      //     10,
                                                                      // buttonradius:
                                                                      //     10,
                                                                      icon: Icons
                                                                          .add,
                                                                      iconColor:
                                                                          Colors
                                                                              .white,
                                                                      iconSize:
                                                                          size.width *
                                                                              0.055,
                                                                      bgcolor:
                                                                          Colors
                                                                              .black,
                                                                      buttonheight:
                                                                          size.width *
                                                                              0.08,
                                                                      buttonwidth:
                                                                          size.width *
                                                                              0.09,
                                                                      onpress:
                                                                          () {
                                                                        final dishIndex = ref
                                                                            .read(quantityProvider
                                                                                .notifier)
                                                                            .state
                                                                            .indexWhere((item) =>
                                                                                item.id ==
                                                                                dishesData![index].dishid);
                                                                        if (dishIndex !=
                                                                            -1) {
                                                                          ref.read(quantityProvider.notifier).update(
                                                                              (state) {
                                                                            state[dishIndex].quantity++;

                                                                            if (ref.read(quantityProvider.notifier).state[dishIndex].quantity >
                                                                                0) {
                                                                              ref.read(showAddProvider.notifier).state = true;
                                                                            }

                                                                            return [
                                                                              ...state
                                                                            ]; // return a new state
                                                                          });
                                                                        }
                                                                      },
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : QuantityButton(
                                                                bgcolor: Colors
                                                                    .white,
                                                                buttonheight:
                                                                    size.width *
                                                                        0.08,
                                                                buttonwidth:
                                                                    size.width *
                                                                        0.09,
                                                                // buttonradius:
                                                                //     10,
                                                                radiustopleft:
                                                                    10,
                                                                radiustopright:
                                                                    10,
                                                                radiusbottomleft:
                                                                    10,
                                                                radiusbottomright:
                                                                    10,
                                                                icon: Icons.add,
                                                                iconColor:
                                                                    Colors.red,
                                                                iconSize:
                                                                    size.width *
                                                                        0.055,
                                                                onpress: () {
                                                                  var dish = ref
                                                                      .read(quantityProvider
                                                                          .notifier)
                                                                      .state
                                                                      .indexWhere((item) =>
                                                                          item.id ==
                                                                          dishesData![index]
                                                                              .dishid);
                                                                  if (dish !=
                                                                      -1) {
                                                                    ref
                                                                        .read(quantityProvider
                                                                            .notifier)
                                                                        .update(
                                                                            (state) {
                                                                      state[dish]
                                                                          .quantity++;

                                                                      return [
                                                                        ...state
                                                                      ];
                                                                    });
                                                                  }
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
                              })
                          : Center(child: Text('No dishes available'));
                    } else {
                      print(widget.rest_uid);
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
