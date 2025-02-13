import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/DummyCart.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/commons/restaurant_container.dart';
import 'package:spicy_eats/features/Basket/screens/basket.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Home/screens/homedrawer.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'dart:math' as math;

import 'package:spicy_eats/main.dart';

var searchProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routename = '/homescreen';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationcontroller;
  late Animation<double> _animationbody;
  bool clicked = false;
  var uid;
  List<RestaurantData> restaurantData = [];
  List<String>? restuid;
  List<DishData> dishList = [];

  @override
  void initState() {
    fetchInitialData();
    // print('_email is: ${supabaseClient.auth.currentUser?.email}');
    // setState(() => isloading = true);
    // //fetch restaurants
    // await ref
    //     .read(registershopcontrollerProvider)
    //     .fetchrestaurants(supabaseClient.auth.currentUser!.id);
    // //fetch rest_uid
    // await ref
    //     .read(registershopcontrollerProvider)
    //     .fetchRestUid(supabaseClient.auth.currentUser!.id);

    // //storing restaurants objects to list
    // await ref
    //     .read(registershopcontrollerProvider)
    //     .fetchrestaurants(supabaseClient.auth.currentUser!.id)
    //     .then((restaurant) {
    //   //  setState(() => isloading = true);
    //   if (restaurant != null) {
    //     setState(() {
    //       restaurantData = restaurant;
    //     });
    //     print('rest_email is: ${restaurantData[0].address}');
    //     print('rest_hours are: ${restaurantData[0].deliveryArea}');
    //   }
    // });
    // //storing rest_uid to a variable
    // await ref
    //     .read(registershopcontrollerProvider)
    //     .fetchRestUid(supabaseClient.auth.currentUser!.id)
    //     .then((value) {
    //   if (value != null) {
    //     ref.watch(rest_ui_Provider.notifier).state = value;
    //     print('initialize restuid provider ${ref.read(rest_ui_Provider)}');
    //     setState(() {
    //       rest_uid = value;
    //     });
    //     //print('rest_uuid is: ${rest_uid}' + '${ref.read(rest_ui_Provider)}');
    //   }
    // });
    // setState(() => isloading = false);

    // await ref.read(homeControllerProvider).fetchDishes(restuid: rest_uid);
    // await ref
    //     .read(homeControllerProvider)
    //     .fetchDishes(restuid: rest_uid)
    //     .then((dishes) {
    //   if (dishes != null) {
    //     setState(() {
    //       dishList = dishes;
    //       print('${dishList[0].cusine!}');
    //     });
    //   }
    // });

    /////////////////////////

    super.initState();
    _animationcontroller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationbody = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationcontroller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationcontroller.dispose();
    super.dispose();
  }

  Future<void> fetchInitialData() async {
    final registershopcontroller = ref.read(registershopcontrollerProvider);

    // Fetch restaurants
    registershopcontroller
        .fetchrestaurants(supabaseClient.auth.currentUser!.id)
        .then((restaurant) {
      if (restaurant != null && mounted) {
        setState(() {
          restaurantData = restaurant;
        });
        print('rest_email is: ${restaurantData[0].address}');
        print('rest_hours are: ${restaurantData[0].deliveryArea}');
      }
    });

    // Fetch rest_uid
    registershopcontroller
        .fetchRestUid(supabaseClient.auth.currentUser!.id)
        .then((value) {
      if (value != null && mounted) {
        // ref.watch(rest_ui_Provider.notifier).state = value;
        //print('initialize restuid provider ${ref.read(rest_ui_Provider)}');
        setState(() {
          restuid = value;
        });
      }
    });

    // Fetch dishes
  }

  void onclick() {
    if (clicked) {
      _animationcontroller.forward();
    } else {
      _animationcontroller.reverse();
    }
  }

  Future<List<Restaurant>> readjsondata() async {
    final data =
        await rootBundle.loadString('lib/assets/data/restaurants.json');
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => Restaurant.fromjson(e)).toList();
  }

  String? rest_name;
  RestaurantData? restaurant;

  @override
  Widget build(BuildContext context) {
    final showCart = ref.watch(showCartButton);
    final cartsize = ref.watch(cartLength);
    var size = MediaQuery.of(context).size;
    var issearch = !ref.watch(searchProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        appBar: PreferredSize(
            preferredSize: ref.read(searchProvider.notifier).state == true
                ? Size.fromHeight(size.width * 0.29)
                : Size.fromHeight(size.width * 0.18),
            child: AppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(
                  255, 29, 29, 29), // The hex code in Flutter

              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              clicked = !clicked;
                              onclick();
                            });
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        Center(
                          child: Column(children: [
                            Text(
                              'Delivering to',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: size.width * 0.04,
                                  color: Colors.white),
                            ),
                            Text(
                              'Riyadh-Saudi Arabia',
                              style: TextStyle(
                                  // GoogleFonts.aBeeZee(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ]),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 94, 81, 81),
                                  //color: Colors.white70,
                                  // color: Color(0x2E2E2E),
                                  // color: Color.fromARGB(0, 92, 86, 86),
                                  borderRadius: BorderRadius.circular(25)
                                  // Hex color in Flutter
                                  ),
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(Icons.search,
                                      size: 30, color: Colors.white),
                                  onPressed: () {
                                    //issearch = !issearch;
                                    ref.read(searchProvider.notifier).state =
                                        !ref
                                            .read(searchProvider.notifier)
                                            .state;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 94, 81, 81),

                                    // color: Colors.red,
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.12 / 2),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () => Navigator.pushNamed(
                                                context, BasketScreen.routename,
                                                arguments: {
                                                  'dish': null,
                                                  'totalprice': 300.0,
                                                  'quantity': 12,
                                                  'cartlist': ref
                                                      .read(cartList.notifier)
                                                      .state,
                                                  'dishes': dishList,
                                                }),
                                        icon: Icon(
                                          Icons.shopping_cart,
                                          size: 30,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                showCart
                                    ? Positioned(
                                        top: 5,
                                        right: 0,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.8),

                                            // color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              12.5,
                                              // size.width * 0.12 / 2
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$cartsize',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ref.read(searchProvider.notifier).state == true
                        ? AnimatedSize(
                            duration: const Duration(microseconds: 900),
                            curve: Curves.linear,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )),
        body: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.all(size.width * 0.03),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         contentPadding: const EdgeInsets.all(10),
            //         prefixIcon: const Icon(Icons.search),
            //         filled: true,
            //         fillColor: Colors.grey[200],
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide.none,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             borderSide: BorderSide.none)),
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // //   const CusinesList(),
            // isloading
            //     ? const CircularProgressIndicator(
            //         backgroundColor: Colors.black12,
            //         value: 20,
            //       )
            //     : Text(' ${restaurantData[0].restaurantName}'),
            Expanded(
              child: Stack(
                children: [
                  // const CusinesList(),
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _animationbody,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_animationbody.value * 100, 0),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(
                                  (_animationbody.value * 20) * math.pi / 180),
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const CusinesList(),
                            // FutureBuilder(
                            //   future: readjsondata(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasError) {
                            //       return const Center(child: Text("Error"));
                            //     } else if (snapshot.hasData) {
                            //       return ListView.builder(
                            //         shrinkWrap: true,
                            //         physics: const NeverScrollableScrollPhysics(),
                            //         itemCount: snapshot.data!.length,
                            //         itemBuilder: ((context, index) {
                            //           restaurant = snapshot.data![index];

                            //           return Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: GestureDetector(
                            //               onTap: () => Navigator.pushNamed(
                            //                   context, RestaurantMenu.routename,
                            //                   arguments: {
                            //                     'restaurant':
                            //                         snapshot.data![index],
                            //                     'dishes': dishList,
                            //                   }),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(10.0),
                            //                 child: RestaurantContainer(
                            //                   name: snapshot.data![index].name,
                            //                   price: snapshot
                            //                       .data![index].deliveryFee
                            //                       .toString(),
                            //                   image: snapshot.data![index].image,
                            //                   mindeliverytime: snapshot
                            //                       .data![index].minDeliveryTime,
                            //                   maxdeliverytime: snapshot
                            //                       .data![index].maxDeliveryTime,
                            //                   ratings:
                            //                       snapshot.data![index].rating,
                            //                 ),
                            //               ),
                            //             ),
                            //           );
                            //         }),
                            //       );
                            //     } else {
                            //       return const Center(
                            //           child: CircularProgressIndicator());
                            //     }
                            //   },
                            // ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.026),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: restaurantData.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    print(MediaQuery.of(context).size.width);

                                    Navigator.pushNamed(
                                      // context, RestaurantMenu.routename,
                                      // arguments: {
                                      //   'restaurant': restaurantData[index],
                                      //   // 'dishes': dishList,
                                      //   'rest_uid':
                                      //       restaurantData[index].restuid,
                                      // }
                                      //     });
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   DummyCart.routename,
                                      //   arguments: restaurantData[index].restuid,
                                      context,
                                      HomeSliverWithScrollableTabs.routename,
                                      arguments: {
                                        'restuid':
                                            restaurantData[index].restuid,
                                        'restaurantdata': restaurantData[index],
                                      },
                                    );
                                  },
                                  child: RestaurantContainer(
                                    name: restaurantData[index]
                                        .restaurantName
                                        .toString(),
                                    price: restaurantData[index]
                                        .deliveryFee
                                        .toString(),
                                    image: restaurantData[index]
                                        .restaurantImageUrl
                                        .toString(),
                                    mindeliverytime:
                                        restaurantData[index].minTime!,
                                    maxdeliverytime:
                                        restaurantData[index].maxTime!,
                                    ratings: restaurantData[index].ratings!,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationbody,
                    builder: (BuildContext context, Widget? child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0), // Starting position
                          end: Offset.zero, // Ending position
                        ).animate(_animationbody),
                        child: HomeDrawer(
                          restuid: restuid,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
