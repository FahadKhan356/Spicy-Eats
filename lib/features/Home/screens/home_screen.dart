import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/commons/ConfirmLocation.dart';
import 'package:spicy_eats/commons/custommap.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Cusines/repository/CusinesRepo.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/widgets/bottomSheet.dart';
import 'package:spicy_eats/features/Home/screens/widgets/restaurant_container.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Home/screens/homedrawer.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/dummyrestaurantmenu.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'dart:math' as math;
// import 'package:geocoding/geocoding.dart';
import 'package:spicy_eats/main.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';

var searchProvider = StateProvider<bool>((ref) => false);
final pickedAddressProvider = StateProvider<AddressModel?>((ref) => null);
final selectedIndexProvider = StateProvider<int?>((ref) => null);
final restaurantlistProvider =
    StateProvider<List<RestaurantModel>>((ref) => []);

final restaurantDisplayListProvider =
    StateProvider<List<RestaurantModel>>((ref) => []);
final cusineListProvider = StateProvider<List<CusinesModel>>((ref) => []);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen(this.locale, {super.key});
  static const String routename = '/homescreen';
  final String? locale;
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  // List<CusinesModel>? allCusines;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData();
    });
    // fetchInitialData();

    super.initState();
    // _animationcontroller = AnimationController(
    //   duration: const Duration(milliseconds: 800),
    //   vsync: this,
    // );

    // _animationbody = Tween<double>(begin: 0, end: 1).animate(
    //     CurvedAnimation(parent: _animationcontroller, curve: Curves.easeInOut));
  }

  List<AddressModel?> allAdress = [];
  List<String>? restuid;
  // List<DishData> dishList = [];
  // LocationResult? _locationResult;
  final userid = supabaseClient.auth.currentUser!.id;
  // bool isloader = true;
  bool showSheet = true;
  Future<void> fetchInitialData() async {
    // final registershopcontroller = ref.read(registershopcontrollerProvider);

    ref.read(restaurantlistProvider.notifier).state =
        await ref.read(registershoprepoProvider).getRestaurantsData();

    ref.read(restaurantDisplayListProvider.notifier).state =
        ref.read(restaurantlistProvider.notifier).state;

    if (!mounted) return;
    await ref
        .read(registershoprepoProvider)
        .fetchFavorites(userid: userid, ref: ref);
    if (mounted) {
      await ref
          .read(profileRepoProvider)
          .fetchCurrentUserData(userid: userid, ref: ref);
    }

    await ref.read(profileRepoProvider).fetchuser(userid, ref);

    allAdress = (await ref
            .read(homeRepositoryController)
            .fetchAllAddress(userId: supabaseClient.auth.currentUser!.id)) ??
        [];

    if (showSheet) {
      _showBottomSheet(addresses: allAdress, isEdit: false);
    }
    final cusines = await ref.read(cusinesRepo).fetchCusines();
    if (mounted) {
      ref.read(cusineListProvider.notifier).state = cusines!;
    }
    ref.read(isloaderProvider.notifier).state = false;
  }

  void _showBottomSheet(
      {required List<AddressModel?> addresses, bool? isEdit}) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        sheetAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut, duration: Duration(milliseconds: 300)),
        enableDrag: true,
        clipBehavior: Clip.none, // no clipping,
        // isScrollControlled: true, // Full height if needed

        builder: (context) {
          return CustomBottomSheet(
            allAdress: allAdress,
            isEdit: isEdit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantData = ref.watch(restaurantDisplayListProvider);
    final allCusines = ref.watch(cusineListProvider);
    final address = ref.watch(pickedAddressProvider);
    final isLoading = ref.watch(isloaderProvider);
    final isSearch = ref.watch(searchProvider);
    final showCart = ref.watch(showCartButton);
    final cartsize = ref.watch(cartLength);
    var size = MediaQuery.of(context).size;
    final expandedHeight = size.height * 0.13;
    final collapsedHeight = size.height * 0.05;
    final searchHeaderHeight = size.width * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Skeletonizer(
          ignorePointers: true,
          ignoreContainers: true,
          enabled: isLoading,
          enableSwitchAnimation: true,
          child: CustomScrollView(
            slivers: [
              // SliverAppBar ONLY for the Address row
              SliverAppBar(
                elevation: 0,
                scrolledUnderElevation:
                    0, // 👈 removes the automatic divider line
                shadowColor: Colors.transparent, // just in case
                pinned: false, // this part should collapse away
                floating: false,
                expandedHeight: expandedHeight,
                collapsedHeight: collapsedHeight,
                toolbarHeight: collapsedHeight,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.orange,
                                  size: size.width * 0.07,
                                ),
                                const SizedBox(width: 6),
                                address != null
                                    ? Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            _showBottomSheet(
                                                addresses: allAdress,
                                                isEdit: true);
                                          },
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Delivering to',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize:
                                                            size.width * 0.036,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.orange),
                                                  ),
                                                ),
                                                Text(
                                                  '${address.address}',
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // GoogleFonts.aBeeZee(
                                                      fontSize:
                                                          size.width * 0.036,
                                                      // fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ]),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          _showBottomSheet(
                                              addresses: allAdress,
                                              isEdit: false);
                                        },
                                        child: Text(
                                          'Select Address',
                                          style: GoogleFonts.aBeeZee(
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          // 🛒 Cart part
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(
                                size.width * 0.025,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize:
                                  MainAxisSize.min, // <--- keep cart compact
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.shopping_cart_outlined,
                                      color: Colors.black),
                                ),
                                Text(
                                  '6',
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Sticky Search Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeaderDelegate(height: searchHeaderHeight),
              ),

              SliverToBoxAdapter(
                child: allCusines.isNotEmpty
                    ? CusinesList(
                        cusineList: allCusines,
                      )
                    : const SizedBox(),
              ),
              // Content list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(registershoprepoProvider).checkIfFavorites(
                            userid: supabaseClient.auth.currentUser!.id,
                            restid: restaurantData[index].restuid!,
                            ref: ref);

                        ref.read(isloaderProvider.notifier).state = true;
                        Navigator.pushNamed(
                          context,
                          // RestaurantMenuScreen.routename,
                          DummyRestaurantMenuScreen.routename,
                          arguments: restaurantData[index],
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20),
                            child: RestaurantContainer(
                              name: restaurantData[index]
                                  .restaurantName
                                  .toString(),
                              price:
                                  restaurantData[index].deliveryFee.toString(),
                              image: restaurantData[index]
                                  .restaurantImageUrl
                                  .toString(),
                              mindeliverytime: restaurantData[index].minTime!,
                              maxdeliverytime: restaurantData[index].maxTime!,
                              ratings: restaurantData[index].averageRatings!,
                              restid: restaurantData[index].restuid!,
                              userid: supabaseClient.auth.currentUser!.id,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: restaurantData.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  _SearchHeaderDelegate({this.height = 64});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final size = MediaQuery.of(context).size;
    final searchHeaderHeight = size.width * 0.2;
    return Container(
      color: Colors.white, // same as AppBar
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
        child: SizedBox(
          height: searchHeaderHeight,
          child: Center(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search for dishes or restaurants",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[200],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }
}

//   late final AnimationController _animationcontroller;
//   late Animation<double> _animationbody;
//   bool clicked = false;
//   final home = Home();
//   // double? _latitude;
//   // double? _longitude;
//   // LocationResult? locationResult;
//   List<CusinesModel>? allCusines;

//   // onCurrentLocation() async {
//   //   locationResult =
//   //       await getLocationResult(latitude: _latitude!, longitude: _longitude!);
//   //   if (mounted) {
//   //     // setState(() {});
//   //     var address = AddressModel(
//   //         userId: supabaseClient.auth.currentUser!.id,
//   //         address: locationResult!.completeAddress,
//   //         lat: locationResult!.latitude!,
//   //         long: locationResult!.longitude!);

//   //     ref.read(pickedAddressProvider.notifier).state = address;
//   //   }
//   // }

//   // List<RestaurantModel> restaurantData = [];
//   List<AddressModel?> allAdress = [];
//   List<String>? restuid;
//   // List<DishData> dishList = [];
//   // LocationResult? _locationResult;
//   final userid = supabaseClient.auth.currentUser!.id;
//   // bool isloader = true;
//   bool showSheet = true;

//   // }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchInitialData();
//     });
//     // fetchInitialData();

//     super.initState();
//     _animationcontroller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _animationbody = Tween<double>(begin: 0, end: 1).animate(
//         CurvedAnimation(parent: _animationcontroller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _animationcontroller.dispose();
//     super.dispose();
//   }

//   // Future<void> filterCusines(
//   //     {required int cusineId,}) async {
//   //   final list = rests!
//   //       .where((element) => element.cuisineIds!.contains(cusineId))
//   //       .toList();

//   //   restaurantData.clear();
//   //   setState(() {
//   //     restaurantData = list;
//   //   });
//   // }

//   Future<void> fetchInitialData() async {
//     // final registershopcontroller = ref.read(registershopcontrollerProvider);

//     ref.read(restaurantlistProvider.notifier).state =
//         await ref.read(registershoprepoProvider).getRestaurantsData();

//     ref.read(restaurantDisplayListProvider.notifier).state =
//         ref.read(restaurantlistProvider.notifier).state;

//     if (!mounted) return;
//     await ref
//         .read(registershoprepoProvider)
//         .fetchFavorites(userid: userid, ref: ref);

//     await ref
//         .read(profileRepoProvider)
//         .fetchCurrentUserData(userid: userid, ref: ref);

//     await ref.read(profileRepoProvider).fetchuser(userid, ref);

//     allAdress = (await ref
//             .read(homeRepositoryController)
//             .fetchAllAddress(userId: supabaseClient.auth.currentUser!.id)) ??
//         [];

//     if (showSheet) {
//       _showBottomSheet(addresses: allAdress, isEdit: false);
//     }
//     final cusines = await ref.read(cusinesRepo).fetchCusines();
//     if (mounted) {
//       setState(() {
//         allCusines = cusines;
//       });
//     }
//     ref.read(isloaderProvider.notifier).state = false;
//   }

//   void onclick() {
//     if (clicked) {
//       _animationcontroller.forward();
//     } else {
//       _animationcontroller.reverse();
//     }
//   }

//   void _showBottomSheet(
//       {required List<AddressModel?> addresses, bool? isEdit}) {
//     showModalBottomSheet(
//         context: context,
//         enableDrag: true,
//         clipBehavior: Clip.none, // no clipping,
//         // isScrollControlled: true, // Full height if needed

//         builder: (context) {
//           return CustomBottomSheet(
//             allAdress: allAdress,
//             isEdit: isEdit,
//           );
//         });
//   }

//   int selectedAddressIndex = 0; // Holds the selected index

//   // final List<String> addresses = [
//   //   "123 Main Street, Hometown albert einstient venue, near cashier siliser",
//   //   "456 Park Avenue, Uptown",
//   //   "789 Sunset Blvd, Midtown",
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     final restaurantData = ref.watch(restaurantDisplayListProvider);
//     final address = ref.watch(pickedAddressProvider);
//     final isLoading = ref.watch(isloaderProvider);
//     final isSearch = ref.watch(searchProvider);
//     final showCart = ref.watch(showCartButton);
//     final cartsize = ref.watch(cartLength);
//     var size = MediaQuery.of(context).size;
//     return
//         // isloader?
//         //     const Scaffold(
//         //         body: Center(
//         //             child: CircularProgressIndicator(
//         //           backgroundColor: Colors.black12,
//         //           color: Colors.black,
//         //         )),
//         //       )
//         // :
//         SafeArea(
//       child: Skeletonizer(
//         ignorePointers: true,
//         ignoreContainers: true,
//         enabled: isLoading,
//         enableSwitchAnimation: true,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           extendBody: true,
//           appBar: PreferredSize(
//               preferredSize: isSearch == true
//                   ? Size.fromHeight(size.width * 0.29)
//                   : Size.fromHeight(size.width * 0.18),
//               child: AppBar(
//                 centerTitle: true,
//                 backgroundColor: const Color.fromARGB(
//                     255, 29, 29, 29), // The hex code in Flutter

//                 flexibleSpace: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Flexible(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   clicked = !clicked;
//                                   onclick();
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.menu,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             address != null
//                                 ? Flexible(
//                                     child: InkWell(
//                                       onTap: () {
//                                         _showBottomSheet(
//                                             addresses: allAdress, isEdit: true);
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 10),
//                                         child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Flexible(
//                                                 child: Text(
//                                                   'Delivering to',
//                                                   style: TextStyle(
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       // GoogleFonts.aBeeZee(
//                                                       fontSize:
//                                                           size.width * 0.036,
//                                                       // fontWeight: FontWeight.bold,
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 '${address.address}',
//                                                 style: TextStyle(
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     // GoogleFonts.aBeeZee(
//                                                     fontSize:
//                                                         size.width * 0.036,
//                                                     // fontWeight: FontWeight.bold,
//                                                     color: Colors.white),
//                                               ),
//                                             ]),
//                                       ),
//                                     ),
//                                   )
//                                 : InkWell(
//                                     onTap: () {
//                                       _showBottomSheet(
//                                           addresses: allAdress, isEdit: false);
//                                     },
//                                     child: Text(
//                                       'Select Address',
//                                       style: GoogleFonts.aBeeZee(
//                                           fontSize: size.width * 0.035,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 children: [
//                                   InkWell(
//                                     onTap: () {},
//                                     child: Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                           color: Colors.orange[900],
//                                           //color: Colors.white70,
//                                           // color: Color(0x2E2E2E),
//                                           // color: Color.fromARGB(0, 92, 86, 86),
//                                           borderRadius:
//                                               BorderRadius.circular(20)
//                                           // Hex color in Flutter
//                                           ),
//                                       child: Center(
//                                         child: IconButton(
//                                           icon: const Icon(Icons.search,
//                                               size: 25, color: Colors.white),
//                                           onPressed: () {
//                                             ref
//                                                     .read(searchProvider.notifier)
//                                                     .state =
//                                                 !ref
//                                                     .read(
//                                                         searchProvider.notifier)
//                                                     .state;

//                                             debugPrint(
//                                                 'searProvider ${ref.watch(searchProvider.notifier).state}');
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   Stack(
//                                     children: [
//                                       Container(
//                                         height: 40,
//                                         width: 40,
//                                         decoration: BoxDecoration(
//                                           color: Colors.orange[900],
//                                           borderRadius: BorderRadius.circular(
//                                               // size.width * 0.12 / 2
//                                               20),
//                                         ),
//                                         child: Center(
//                                           child: IconButton(
//                                               onPressed: () {},
//                                               icon: const Icon(
//                                                 Icons.shopping_cart,
//                                                 size: 25,
//                                                 color: Colors.white,
//                                               )),
//                                         ),
//                                       ),
//                                       showCart
//                                           ? Positioned(
//                                               top: 5,
//                                               right: 0,
//                                               child: Container(
//                                                 height: 25,
//                                                 width: 25,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red
//                                                       .withOpacity(0.8),

//                                                   // color: Colors.red,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     12.5,
//                                                     // size.width * 0.12 / 2
//                                                   ),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     '$cartsize',
//                                                     style: const TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           : const SizedBox(),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       isSearch == true
//                           ? AnimatedSize(
//                               duration: const Duration(microseconds: 900),
//                               curve: Curves.linear,
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.all(10),
//                                     prefixIcon: const Icon(Icons.search),
//                                     filled: true,
//                                     fillColor: Colors.grey[200],
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide.none,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                         borderSide: BorderSide.none)),
//                               ),
//                             )
//                           : const SizedBox(),
//                     ],
//                   ),
//                 ),
//               )),
//           body:
//               //isloader
//               // ? const Center(
//               //     child: CircularProgressIndicator(),
//               //   )
//               // :
//               Column(
//             children: [
//               Expanded(
//                 child: Stack(
//                   children: [
//                     // const CusinesList(),
//                     RepaintBoundary(
//                       child: AnimatedBuilder(
//                         animation: _animationbody,
//                         builder: (context, child) {
//                           return Transform.translate(
//                             offset: Offset(_animationbody.value * 100, 0),
//                             child: Transform(
//                               alignment: Alignment.center,
//                               transform: Matrix4.identity()
//                                 ..setEntry(3, 2, 0.001)
//                                 ..rotateY((_animationbody.value * 20) *
//                                     math.pi /
//                                     180),
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               allCusines != null
//                                   ? CusinesList(
//                                       cusineList: allCusines,
//                                     )
//                                   : const SizedBox(),
//                               const SizedBox(height: 10),
//                               Padding(
//                                 padding: EdgeInsets.all(size.width * 0.026),
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: restaurantData.length,
//                                   itemBuilder: (context, index) =>
//                                       GestureDetector(
//                                     onTap: () {
//                                       ref
//                                           .read(registershoprepoProvider)
//                                           .checkIfFavorites(
//                                               userid: supabaseClient
//                                                   .auth.currentUser!.id,
//                                               restid: restaurantData[index]
//                                                   .restuid!,
//                                               ref: ref);
//                                       print(MediaQuery.of(context).size.width);

//                                       ref
//                                           .read(isloaderProvider.notifier)
//                                           .state = true;
//                                       Navigator.pushNamed(
//                                         context,
//                                         RestaurantMenuScreen.routename,
//                                         arguments: restaurantData[index],
//                                       );
//                                     },
//                                     child: Column(
//                                       children: [
//                                         // ...List.generate(
//                                         //     restaurantData[index]
//                                         //         .cuisineIds!
//                                         //         .length,
//                                         //     (e) => Text(
//                                         //         style: TextStyle(
//                                         //             fontSize: 20,
//                                         //             color: Colors.red),
//                                         //         restaurantData[index]
//                                         //             .cuisineIds![e]
//                                         //             .toString())),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10.0, vertical: 20),
//                                           child: RestaurantContainer(
//                                             name: restaurantData[index]
//                                                 .restaurantName
//                                                 .toString(),
//                                             price: restaurantData[index]
//                                                 .deliveryFee
//                                                 .toString(),
//                                             image: restaurantData[index]
//                                                 .restaurantImageUrl
//                                                 .toString(),
//                                             mindeliverytime:
//                                                 restaurantData[index].minTime!,
//                                             maxdeliverytime:
//                                                 restaurantData[index].maxTime!,
//                                             ratings: restaurantData[index]
//                                                 .averageRatings!,
//                                             restid:
//                                                 restaurantData[index].restuid!,
//                                             userid: supabaseClient
//                                                 .auth.currentUser!.id,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               // ...List.generate(
//                               //     restaurantData.length,
//                               //     (e) => ListView.builder(
//                               //         shrinkWrap: true,
//                               //         itemCount:
//                               //             restaurantData[e].cuisineIds?.length,
//                               //         itemBuilder: (context, index) =>
//                               //             Text('aaaaa'))),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     AnimatedBuilder(
//                       animation: _animationbody,
//                       builder: (BuildContext context, Widget? child) {
//                         return SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(-1, 0), // Starting position
//                             end: Offset.zero, // Ending position
//                           ).animate(_animationbody),
//                           child: HomeDrawer(
//                             restuid: restuid,
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
