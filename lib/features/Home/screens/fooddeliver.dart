import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Cusines/repository/CusinesRepo.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Home/screens/widgets/bottomSheet.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Home/screens/widgets/restaurant_container.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/main.dart';

class FoodDeliveryScreen extends ConsumerStatefulWidget {
  const FoodDeliveryScreen({super.key});

  @override
  ConsumerState<FoodDeliveryScreen> createState() => _FoodDeliveryScreenState();
}

class _FoodDeliveryScreenState extends ConsumerState<FoodDeliveryScreen> {
  List<CusinesModel>? allCusines;

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

    await ref
        .read(profileRepoProvider)
        .fetchCurrentUserData(userid: userid, ref: ref);

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
      setState(() {
        allCusines = cusines;
      });
    }
    ref.read(isloaderProvider.notifier).state = false;
  }

  void _showBottomSheet(
      {required List<AddressModel?> addresses, bool? isEdit}) {
    showModalBottomSheet(
        context: context,
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
      body: SafeArea(
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
                    padding: const EdgeInsets.all(8.0),
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
              child: allCusines != null
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
                      print(MediaQuery.of(context).size.width);

                      ref.read(isloaderProvider.notifier).state = true;
                      Navigator.pushNamed(
                        context,
                        RestaurantMenuScreen.routename,
                        arguments: restaurantData[index],
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
                          child: RestaurantContainer(
                            name:
                                restaurantData[index].restaurantName.toString(),
                            price: restaurantData[index].deliveryFee.toString(),
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
      color: Colors.black, // same as AppBar
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: searchHeaderHeight - 70, horizontal: size.width * 0.025),
        child: SizedBox(
          height: searchHeaderHeight - 10,
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for dishes or restaurants",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
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
