import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Register%20shop/controller/registershop_controller.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/features/Home/screens/widgets/restaurant_container.dart';
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
  bool showSheet = true;

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
    // await registershopcontroller.fetchrestaurants().then((restaurant) {
    //   if (restaurant != null && mounted) {
    //     setState(() {
    //       restaurantData = restaurant;
    //     });
    //     print('rest_email is: ${restaurantData[0].address}');
    //     print('rest_hours are: ${restaurantData[0].deliveryArea}');
    //   }
    // });
    restaurantData =
        await ref.read(registershoprepoProvider).getRestaurantsData();

    // Fetch rest_uid
    // await registershopcontroller
    //     .fetchRestUid(supabaseClient.auth.currentUser!.id)
    //     .then((value) {
    //   if (value != null && mounted) {
    //     // ref.watch(rest_ui_Provider.notifier).state = value;
    //     //print('initialize restuid provider ${ref.read(rest_ui_Provider)}');
    //     setState(() {
    //       restuid = value;
    //     });
    //   }
    // });

    // Fetch favorites
    if (!mounted) return;
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

    if (showSheet) {
      _showBottomSheet();
    }
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
  void _showBottomSheet() {
    final width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full height if needed
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) => Container(
            height: 400,
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Fit content
                children: [
                  const Text(
                    "Where’s your food going? 🍕",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on),
                      Text(
                        "Choose current location",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<int>(
                                  fillColor: WidgetStateProperty.all(
                                      Colors.orange[900]),
                                  value:
                                      index, // each radio gets its index as value
                                  groupValue:
                                      selectedAddressIndex, // selected one
                                  onChanged: (value) {
                                    setStateModal(() {
                                      selectedAddressIndex = value;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: InkWell(
                                      onTap: () {
                                        setStateModal(() {
                                          selectedAddressIndex =
                                              index; // also allow tap on row
                                        });
                                      },
                                      child: Text(
                                        addresses[index],
                                        style: TextStyle(
                                            overflow: TextOverflow.visible,
                                            fontWeight:
                                                selectedAddressIndex == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                      )),
                                ),
                              ]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                        arguments: true, context, MyMap.routename),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                        Text("Add new address",
                            style: TextStyle(
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.black,
                    height: 1,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(width * 0.14),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  spreadRadius: 2,
                                  color: Color.fromRGBO(230, 81, 0, 1),
                                  blurRadius: 2)
                            ],
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(width * 0.14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Text("Confirm location",
                                  style: TextStyle(
                                      color: Colors.orange[900],
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int? selectedAddressIndex; // Holds the selected index

  final List<String> addresses = [
    "123 Main Street, Hometown albert einstient venue, near cashier siliser",
    "456 Park Avenue, Uptown",
    "789 Sunset Blvd, Midtown",
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSearch = ref.watch(searchProvider);
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
        SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        appBar: PreferredSize(
            preferredSize: isSearch == true
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.orange[900],
                                      //color: Colors.white70,
                                      // color: Color(0x2E2E2E),
                                      // color: Color.fromARGB(0, 92, 86, 86),
                                      borderRadius: BorderRadius.circular(20)
                                      // Hex color in Flutter
                                      ),
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.search,
                                          size: 25, color: Colors.white),
                                      onPressed: () {
                                        ref
                                                .read(searchProvider.notifier)
                                                .state =
                                            !ref
                                                .read(searchProvider.notifier)
                                                .state;

                                        debugPrint(
                                            'searProvider ${ref.watch(searchProvider.notifier).state}');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.orange[900],
                                      borderRadius: BorderRadius.circular(
                                          // size.width * 0.12 / 2
                                          20),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            size: 25,
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isSearch == true
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
                              const SizedBox(
                                height: 20,
                              ),

                              // Cusines List

                              const CusinesList(),
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
                                      ref
                                          .read(registershoprepoProvider)
                                          .checkIfFavorites(
                                              userid: supabaseClient
                                                  .auth.currentUser!.id,
                                              restid: restaurantData[index]
                                                  .restuid!,
                                              ref: ref);
                                      print(MediaQuery.of(context).size.width);

                                      Navigator.pushNamed(
                                        context,
                                        RestaurantMenuScreen.routename,
                                        arguments: restaurantData[index],
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20),
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
    );
  }
}
