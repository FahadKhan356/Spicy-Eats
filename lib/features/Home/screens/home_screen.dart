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
import 'package:spicy_eats/commons/Responsive.dart';
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
    var size = MediaQuery.of(context).size;
    final expandedHeight = Responsive.h100px ;
    final collapsedHeight = Responsive.h36px;
    final searchHeaderHeight = Responsive.h50px;

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
                backgroundColor: Colors.black,
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
                                  size: Responsive.w28px,
                                ),
                                 SizedBox(width: Responsive.w6px),
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
                                                            Responsive.w14px,
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
                                                   
                                                      fontSize:
                                                          Responsive.w14px,
                                                   
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
                                              fontSize:Responsive.w14px,
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
                                Responsive.w10px,
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
                                    fontSize: Responsive.w20px,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: Responsive.w10px, vertical: Responsive.h20px),
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


    return Container(
      color: Colors.black, // same as AppBar
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w10px),
        child: SizedBox(
          height: height,
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


