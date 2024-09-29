import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

final quantityProvider = StateProvider<List<ItemQuantity>>((ref) => []);

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

class _RestaurantMenuState extends ConsumerState<RestaurantMenu> {
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Row(
                  children: [
                    Text(
                      "\$ ${widget.restaurant!.ratings}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.star,
                      size: 22,
                      color: Colors.amber,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: dishData!.length,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: ((context, index) {
              //       return Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Divider(
              //             height: 4,
              //             thickness: 4,
              //             color: Colors.black26,
              //           ),

              //           // leading: Image.network(
              //           //   restaurant.dishes[index].image.toString(),
              //           //   width: 100,
              //           //   height: 100,
              //           // ),
              //           // GestureDetector(
              //           //   onTap: () => Navigator.pushNamed(
              //           //       context, MenuItemDetailScreen.routename,
              //           //       arguments: dishData![index]),
              //           //   child: DishesCard(
              //           //     dishname: dishData![index].dish_name.toString(),
              //           //     dishdescription:
              //           //         dishData![index].dish_description.toString(),
              //           //     dishprice: dishData![index].dish_price.toString(),
              //           //     image: dishData![index].dish_imageurl.toString(),
              //           //     index: index,
              //           //   ),
              //           // ),
              //           const SizedBox(
              //             height: 20,
              //           ),
              //         ],
              //       );
              //     })),
              const SizedBox(
                height: 20,
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: dishData!.length,
              //   itemBuilder: (context, index) => DishesCard(
              //     dishname: dishData![index].dish_name!,
              //     dishdescription: dishData![index].dish_description!,
              //     dishprice: dishData![index].dish_price!.toString(),
              //     image: dishData![index].dish_imageurl,
              //     index: index,
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                  future: ref
                      .read(homeControllerProvider)
                      .fetchDishes(restuid: ref.read(rest_ui_Provider)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // WidgetsBinding.instance
                      //     .addPostFrameCallback((_) {
                      //   mysnackbar(
                      //       context: context,
                      //       text: 'data is fetching...');
                      // });
                      return const CircularProgressIndicator();
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
                        itemBuilder: (context, index) => Padding(
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
                                          widget.dishData![index].dish_imageurl!
                                              .isNotEmpty
                                      ? Image.network(
                                          widget
                                              .dishData![index].dish_imageurl!,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.dishData![index].dish_name!,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.dishData![index]
                                              .dish_description!,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\$ ${widget.dishData![index].dish_price}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      QuantityButton(
                                        buttonheight: 40,
                                        icon: Icons.remove,
                                        iconColor: Colors.black,
                                        iconSize: 30,
                                        bgcolor: Colors.white,
                                        onpress: () {
                                          int dishindex = ref
                                              .read(quantityProvider.notifier)
                                              .state
                                              .indexWhere((element) =>
                                                  element.id ==
                                                  widget
                                                      .dishData![index].dishid);

                                          if (dishindex != -1) {
                                            ref
                                                .read(quantityProvider.notifier)
                                                .update((state) {
                                              if (state[dishindex].quantity >
                                                  0) {
                                                state[dishindex].quantity--;
                                              }
                                              return [...state];
                                            });
                                          }
                                        },
                                      ),
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final quantity = ref
                                              .watch(quantityProvider)
                                              .firstWhere((item) =>
                                                  item.id ==
                                                  widget
                                                      .dishData![index].dishid)
                                              .quantity;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "Quantity: $quantity",
                                              style: const TextStyle(
                                                fontSize: 28,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      QuantityButton(
                                        icon: Icons.add,
                                        iconColor: Colors.black,
                                        iconSize: 30,
                                        bgcolor: Colors.white,
                                        buttonheight: 40,
                                        onpress: () {
                                          final dishIndex = ref
                                              .read(quantityProvider.notifier)
                                              .state
                                              .indexWhere((item) =>
                                                  item.id ==
                                                  widget
                                                      .dishData![index].dishid);
                                          if (dishIndex != -1) {
                                            ref
                                                .read(quantityProvider.notifier)
                                                .update((state) {
                                              state[dishIndex].quantity++;
                                              return [
                                                ...state
                                              ]; // return a new state
                                            });
                                          }
                                        },
                                      )
                                      // QuantityButton(
                                      //   icon: Icons.add,
                                      //   iconColor: Colors.black,
                                      //   iconSize: 30,
                                      //   bgcolor: Colors.white,
                                      //   buttonheight: 40,
                                      //   onpress: () {
                                      //     if (ref
                                      //             .watch(
                                      //                 quantityProvider.notifier)
                                      //             .state[index]
                                      //             .id ==
                                      //         widget.dishData![index].dishid) {
                                      //       ref
                                      //           .watch(
                                      //               quantityProvider.notifier)
                                      //           .state[index]
                                      //           .quantity++;
                                      //       // ref
                                      //       //     .watch(
                                      //       //         quantityProvider.notifier)
                                      //       //     .state[index]
                                      //       //     .quantity++;

                                      //       //setState(() {});
                                      //       // ref
                                      //       //     .watch(
                                      //       //         quantityProvider.notifier)
                                      //       //     .update((state) =>
                                      //       //         ref.read(quantityProvider));
                                      //     }
                                      //     print(
                                      //         ' this id id from quantityprovider ${ref.watch(quantityProvider.notifier).state[index].id}....this id is from dishData: ${widget.dishData![index].dishid}');

                                      //     // final dishIndex = ref
                                      //     //     .watch(quantityProvider.notifier)
                                      //     //     .state
                                      //     //     .indexWhere((item) =>
                                      //     //         item.id ==
                                      //     //         widget
                                      //     //             .dishData![index].dishid);

                                      //     // ref
                                      //     //     .read(quantityProvider.notifier)
                                      //     //     .update((state) => state
                                      //     //       ..[dishIndex].quantity =
                                      //     //           (state[dishIndex].quantity >
                                      //     //                   0)
                                      //     //               ? state[dishIndex]
                                      //     //                       .quantity -
                                      //     //                   1
                                      //     //               : 0);
                                      //     print(
                                      //         'quantity::${ref.read(quantityProvider)[index].quantity}');
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // DishesCard(
                        //       dishname:
                        //           dishes[index].dish_name.toString(),
                        //       dishdescription: dishes[index]
                        //           .dish_description
                        //           .toString(),
                        //       dishprice:
                        //           dishes[index].dish_price.toString(),
                        //       index: index,
                        //       image: dishes[index].dish_imageurl,
                        //     )
                      );
                    } else {
                      // Handle the case where there is no data
                      return const Center(child: Text('No dishes available'));
                    }
                  }),

              // ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: listuniqueDish.length,
              //     itemBuilder: (context, index) => Text(
              //           uniqueDish[index].id.toString(),
              //           style: const TextStyle(fontSize: 30),
              //         ))
            ],
          ),
        ),
      ),
    );
  }
}
