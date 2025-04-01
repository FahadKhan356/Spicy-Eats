import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/commons/restaurant_container.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/homedrawer.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'dart:math' as math;

import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/tabexample.dart/RestaurantMenuScreen.dart';

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
  final home = Home();

  List<RestaurantModel> restaurantData = [];
  List<String>? restuid;
  // List<DishData> dishList = [];
  final userid = supabaseClient.auth.currentUser!.id;
  bool isloader = true;

  @override
  void initState() {
    fetchInitialData();

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
    setState(() {
      isloader = true;
    });
    final registershopcontroller = ref.read(registershopcontrollerProvider);

    // Fetch restaurants
    await registershopcontroller.fetchrestaurants().then((restaurant) {
      if (restaurant != null && mounted) {
        setState(() {
          restaurantData = restaurant;
        });
        print('rest_email is: ${restaurantData[0].address}');
        print('rest_hours are: ${restaurantData[0].deliveryArea}');
      }
    });

    // Fetch rest_uid
    await registershopcontroller
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

    // Fetch favorites
    await ref
        .read(registershoprepoProvider)
        .fetchFavorites(userid: userid, ref: ref);
    setState(() {
      isloader = false;
    });

    await ref
        .read(profileRepoProvider)
        .fetchCurrentUserData(userid: userid, ref: ref);

    await ref.read(profileRepoProvider).fetchuser(userid, ref);
  }

  void onclick() {
    if (clicked) {
      _animationcontroller.forward();
    } else {
      _animationcontroller.reverse();
    }
  }

  // Future<List<Restaurant>> readjsondata() async {
  //   final data =
  //       await rootBundle.loadString('lib/assets/data/restaurants.json');
  //   final list = jsonDecode(data) as List<dynamic>;
  //   return list.map((e) => Restaurant.fromjson(e)).toList();
  // }

  // String? rest_name;
  // RestaurantModel? restaurant;

  @override
  Widget build(BuildContext context) {
    final showCart = ref.watch(showCartButton);
    final cartsize = ref.watch(cartLength);
    var size = MediaQuery.of(context).size;
    return
        // isloader?
        //     const Scaffold(
        //         body: Center(
        //             child: CircularProgressIndicator(
        //           backgroundColor: Colors.black12,
        //           color: Colors.black,
        //         )),
        //       )
        // :
        Skeletonizer(
      enabled: isloader,
      enableSwitchAnimation: true,
      child: SafeArea(
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
                                    color:
                                        const Color.fromARGB(255, 94, 81, 81),
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
                                          onPressed: () {},
                                          icon: const Icon(
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
                                              color:
                                                  Colors.red.withOpacity(0.8),

                                              // color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12.5,
                                                // size.width * 0.12 / 2
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$cartsize',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          : const SizedBox(),
                    ],
                  ),
                ),
              )),
          body:
              //isloader
              // ? const Center(
              //     child: CircularProgressIndicator(),
              //   )
              // :
              Skeletonizer(
            containersColor: Colors.black12,
            enableSwitchAnimation: true,
            enabled: isloader,
            child: Column(
              children: [
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
                                  ..rotateY((_animationbody.value * 20) *
                                      math.pi /
                                      180),
                                child: child,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const CusinesList(),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.all(size.width * 0.026),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: restaurantData.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(registershoprepoProvider)
                                            .checkIfFavorites(
                                                userid: supabaseClient
                                                    .auth.currentUser!.id,
                                                restid: restaurantData[index]
                                                    .restuid!,
                                                ref: ref);
                                        print(
                                            MediaQuery.of(context).size.width);

                                        Navigator.pushNamed(
                                          context,
                                          RestaurantMenuScreen.routename,
                                          arguments: restaurantData[index],
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
                                        ratings: restaurantData[index]
                                            .averageRatings!,
                                        restid: restaurantData[index].restuid!,
                                        userid:
                                            supabaseClient.auth.currentUser!.id,
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
        ),
      ),
    );
  }
}
