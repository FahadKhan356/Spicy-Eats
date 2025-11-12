import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/commons/Lists.dart';
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Cusines/repository/CusinesRepo.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/widgets/HomeBannersCrousel.dart';
import 'package:spicy_eats/features/Home/screens/widgets/RestaurantNearYou.dart';
import 'package:spicy_eats/features/Location/Widgets/bottomSheet.dart';
import 'package:spicy_eats/features/Home/screens/widgets/restaurant_container.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
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

final crouselIndicatorProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen(this.locale, {super.key});
  static const String routename = '/homescreen';
  final String? locale;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final Future<void> _initialDataFuture;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    _initialDataFuture = fetchInitialData();
    ref
        .read(cartReopProvider)
        .initializeCart(userId: supabaseClient.auth.currentUser!.id, ref: ref);
    // });

    super.initState();
  }

  List<AddressModel>? allAdress = [];
  List<String>? restuid;
  final userid = supabaseClient.auth.currentUser!.id;
  String? lastLocation;
  bool? flag;
  List<RestaurantModel> nearByRestaurants = [];
  Future<void> fetchLastLocation() async {
    final data = await LocationLocalDatabase.instance
        .getLocationWithFlag('LocationData');

    if (data != null) {
      flag = data['flag'] as bool;
      lastLocation = data['lastLocation'] as String?;
    }
  }

  Future<void> fetchInitialData() async {
    await ref.read(profileRepoProvider).fetchuser(userid, ref);

    ref.read(restaurantlistProvider.notifier).state =
        await ref.read(homeRepositoryController).getRestaurantsData();

    if (ref.read(restaurantlistProvider).isNotEmpty) {
      debugPrint('not empty');
      nearByRestaurants =
          await ref.read(homeRepositoryController).getNearbyRestaurants(
                allRestaurants: ref.read(restaurantlistProvider.notifier).state,
                userLat: ref.read(userProvider)!.latitude!,
                userLong: ref.read(userProvider)!.longitude!, // 67.06,
              );
      debugPrint('length of nearby: ${nearByRestaurants.length}');
    } else {
      debugPrint('⚠️ No restaurants fetched from Supabase');
    }

    allAdress = await ref
            .read(homeRepositoryController)
            .fetchAllAddress(userId: supabaseClient.auth.currentUser!.id) ??
        [];
    fetchLastLocation();

    ref.read(restaurantDisplayListProvider.notifier).state =
        ref.read(restaurantlistProvider.notifier).state;

    if (!mounted) return;
    await ref
        .read(homeRepositoryController)
        .fetchFavorites(userid: userid, ref: ref);
    if (mounted) {
      await ref
          .read(profileRepoProvider)
          .fetchCurrentUserData(userid: userid, ref: ref);
    }

    await ref.read(profileRepoProvider).fetchuser(userid, ref);

    final cusines = await ref.read(cusinesRepo).fetchCusines();
    if (mounted) {
      ref.read(cusineListProvider.notifier).state = cusines!;
    }
    ref.read(isloaderProvider.notifier).state = false;

    _showBottomSheet(addresses: allAdress!, isEdit: false);
  }

  Future<void> _showBottomSheet(
      {required List<AddressModel?> addresses, bool? isEdit}) async {
    if (flag! || isEdit == true) {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          barrierColor: Colors.black.withOpacity(0.5),
          showDragHandle: true,
          context: context,
          sheetAnimationStyle: AnimationStyle(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300)),
          enableDrag: true,
          clipBehavior: Clip.none,
          builder: (context) {
            return CustomBottomSheet(
              lastLocation: lastLocation,
              allAdress: addresses,
              isEdit: isEdit,
            );
          }).whenComplete(() async {
        // ✅ Called no matter how the sheet is closed.
        final picked = ref.read(pickedAddressProvider);
        if (picked == null) {
          // User didn’t select anything → mark flag false
          await LocationLocalDatabase.instance
              .setLocationWithFlag('LocationData', false, lastLocation ?? '');
          debugPrint(
              'BottomSheet closed without selection → flag set to false');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantData = ref.watch(restaurantDisplayListProvider);
    final allCusines = ref.watch(cusineListProvider);
    final address = ref.watch(pickedAddressProvider);
    final isLoading = ref.watch(isloaderProvider);
    final cart = ref.watch(cartProvider);
    final crouselIndicator = ref.watch(crouselIndicatorProvider);

    final expandedHeight = Responsive.w100px;
    final collapsedHeight = Responsive.h36px;
    final searchHeaderHeight = Responsive.w70px;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: FutureBuilder(
            future: _initialDataFuture,
            builder: (context, snapshot) {
              final loading = snapshot.connectionState != ConnectionState.done;

              return CustomScrollView(
                slivers: [
                  // Enhanced SliverAppBar for Address
                  SliverAppBar(
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    shadowColor: Colors.transparent,
                    pinned: false,
                    floating: false,
                    expandedHeight: expandedHeight,
                    collapsedHeight: collapsedHeight,
                    toolbarHeight: collapsedHeight,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.orange[700]!,
                              Colors.orange[500]!,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(Responsive.w20px),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(Responsive.w8px),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: Responsive.w20px,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // here was container
                                      SizedBox(width: Responsive.w10px),
                                      address != null
                                          ? Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  _showBottomSheet(
                                                      addresses: allAdress!,
                                                      isEdit: true);
                                                },
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Delivering to',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: Responsive
                                                                .w12px,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9)),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              Responsive.h5px),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              '${address.address}',
                                                              style: TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      Responsive
                                                                          .w14px,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: Colors.white,
                                                            size: Responsive
                                                                .w16px,
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            )
                                          : Expanded(
                                              // FIXED: Added Expanded here too
                                              child: InkWell(
                                                onTap: () {
                                                  _showBottomSheet(
                                                      addresses: allAdress!,
                                                      isEdit: true);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    lastLocation != null
                                                        ? Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Delivering to',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Responsive
                                                                              .w12px,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.9)),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        Responsive
                                                                            .h5px),
                                                                Text(
                                                                  lastLocation
                                                                      .toString(),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // FIXED: Changed to ellipsis
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Responsive
                                                                              .w14px,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Text(
                                                            'Select Address',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Responsive
                                                                        .w14px,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.white,
                                                      size: Responsive.w16px,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                // Cart Button
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.shopping_cart_outlined,
                                            size: Responsive.w20px,
                                            color: Colors.white),
                                      ),
                                      if (cart.isNotEmpty)
                                        Positioned(
                                          top: Responsive.w8px,
                                          right: 0, //Responsive.w8px,
                                          child: Container(
                                            height: Responsive.w20px,
                                            width: Responsive.w20px,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                )),
                                            child: Center(
                                              child: Text(
                                                cart.length.toString(),
                                                style: TextStyle(
                                                  fontSize: Responsive.w10px,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
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
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchHeaderDelegate(height: searchHeaderHeight),
                  ),
                  SliverToBoxAdapter(
                    child: Skeletonizer(
                        ignorePointers: true,
                        ignoreContainers:
                            false, // Changed this to false for better coverage
                        enabled: loading,
                        enableSwitchAnimation: true,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // Banner Carousel
                            loading
                                ? const SizedBox(
                                    height: 180,
                                    width: 400,
                                  )
                                : HomeBannersCrousel(
                                    ref: ref,
                                    crouselIndicator: crouselIndicator),

                            // Cuisines Section
                            allCusines.isNotEmpty
                                ? CusinesList(cusineList: allCusines)
                                : const SizedBox(),

                            const SizedBox(
                              height: 10,
                            ),
                            // Banner Carousel

                            // Restaurants Section Header
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.w20px,
                                vertical: Responsive.h16px,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(Responsive.w8px),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.restaurant,
                                      color: Colors.orange[700],
                                      size: Responsive.w20px,
                                    ),
                                  ),
                                  SizedBox(width: Responsive.w12px),
                                  Text(
                                    'Restaurants Near You',
                                    style: TextStyle(
                                      fontSize: Responsive.w18px,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RestaurantNearYou(
                              nearByRestaurants: nearByRestaurants,
                            ),
                            // Restaurant List
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: restaurantData.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(homeRepositoryController)
                                        .checkIfFavorites(
                                            userid: supabaseClient
                                                .auth.currentUser!.id,
                                            restid:
                                                restaurantData[index].restuid!,
                                            ref: ref);

                                    ref.read(isloaderProvider.notifier).state =
                                        true;
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
                                    ratings:
                                        restaurantData[index].averageRatings!,
                                    restid: restaurantData[index].restuid!,
                                    userid: supabaseClient.auth.currentUser!.id,
                                  ),
                                );
                              },
                            ),

                            // Bottom Spacing
                            SizedBox(height: Responsive.h20px),
                          ],
                        )),
                  ),
                  // Sticky Search Bar
                ],
              );
            }),
      ),
    );
  }
}

// Enhanced Search Header Delegate
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.w20px, vertical: Responsive.w10px),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Search for dishes or restaurants",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: Responsive.w14px,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: Responsive.w20px,
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(Responsive.w8px),
                padding: EdgeInsets.all(Responsive.w8px),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: Responsive.w16px,
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Responsive.w16px,
                vertical: Responsive.h14px,
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
