import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Cart/repository/CartRepository.dart';
import 'package:spicy_eats/features/Cusines/model/CusinesModel.dart';
import 'package:spicy_eats/features/Cusines/repository/CusinesRepo.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/widgets/bottomSheet.dart';
import 'package:spicy_eats/features/Home/screens/widgets/restaurant_container.dart';
import 'package:spicy_eats/features/Home/screens/widgets/cusineslist.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
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


final crouselIndicatorProvider=StateProvider<int>((ref)=>0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen(this.locale, {super.key});
  static const String routename = '/homescreen';
  final String? locale;
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData();
      ref.read(cartReopProvider).initializeCart(
          userId: supabaseClient.auth.currentUser!.id, ref: ref);
    });
    super.initState();
  }

  List<AddressModel?> allAdress = [];
  List<String>? restuid;
  final userid = supabaseClient.auth.currentUser!.id;
  bool showSheet = true;
  

  Future<void> fetchInitialData() async {
    ref.read(restaurantlistProvider.notifier).state =
        await ref.read(homeRepositoryController).getRestaurantsData();

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
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
        showDragHandle: true,
        context: context,
        sheetAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut, duration:const Duration(milliseconds: 300)),
        enableDrag: true,
        clipBehavior: Clip.none,
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
    final cart = ref.watch(cartProvider);
    final crouselIndicator= ref.watch(crouselIndicatorProvider);

    final expandedHeight = Responsive.w100px;
    final collapsedHeight = Responsive.h36px;
    final searchHeaderHeight = Responsive.w70px;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Skeletonizer(
          ignorePointers: true,
          ignoreContainers: true,
          enabled: isLoading,
          enableSwitchAnimation: true,
          child: CustomScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                 // here was container
                                  SizedBox(width: Responsive.w10px),
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
                                                  Text(
                                                    'Delivering to',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: Responsive.w12px,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white
                                                            .withOpacity(0.9)),
                                                  ),
                                                  SizedBox(height: Responsive.h5px),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          '${address.address}',
                                                          style: TextStyle(
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              fontSize:
                                                                  Responsive.w14px,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors.white),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Colors.white,
                                                        size: Responsive.w16px,
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            _showBottomSheet(
                                                addresses: allAdress, isEdit: false);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Select Address',
                                                style: TextStyle(
                                                    fontSize: Responsive.w14px,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.white,
                                                size: Responsive.w16px,
                                              ),
                                            ],
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

              // Sticky Search Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchHeaderDelegate(height: searchHeaderHeight),
              ),

              // Cuisines Section
              SliverToBoxAdapter(
                child: allCusines.isNotEmpty
                    ? CusinesList(cusineList: allCusines)
                    : const SizedBox(),
              ),

              // Banner Carousel
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        onPageChanged: (index,r){
                         WidgetsBinding.instance.addPostFrameCallback((_){
ref.read(crouselIndicatorProvider.notifier).state=index;
                         });
                          
                        
                        },
                        height: 160.0,
                        autoPlay: true,
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      ),
                      items: bannerImages.map((e) {
                        return Builder(
                          builder: (context) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                e,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                                                       
                                                       
                          ),
                        );
                      }).toList(),
                    ),
                   const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerImages.length, (index){
                      
                      final isActive=crouselIndicator==index;
                       return  AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.bounceIn,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: Responsive.h5px,
                          width: isActive? Responsive.w14px : Responsive.w7px,
                         decoration:  BoxDecoration( borderRadius:BorderRadius.circular(5),color:  Colors.orange),
                         );}
                         ),) 
                  
                  
                  ],
                ),
              ),

              // Restaurants Section Header
              SliverToBoxAdapter(
                child: Padding(
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
              ),

              // Restaurant List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(homeRepositoryController).checkIfFavorites(
                            userid: supabaseClient.auth.currentUser!.id,
                            restid: restaurantData[index].restuid!,
                            ref: ref);

                        ref.read(isloaderProvider.notifier).state = true;
                        Navigator.pushNamed(
                          context,
                          RestaurantMenuScreen.routename,
                          arguments: restaurantData[index],
                        );
                      },
                      child: RestaurantContainer(
                        name: restaurantData[index].restaurantName.toString(),
                        price: restaurantData[index].deliveryFee.toString(),
                        image: restaurantData[index].restaurantImageUrl.toString(),
                        mindeliverytime: restaurantData[index].minTime!,
                        maxdeliverytime: restaurantData[index].maxTime!,
                        ratings: restaurantData[index].averageRatings!,
                        restid: restaurantData[index].restuid!,
                        userid: supabaseClient.auth.currentUser!.id,
                      ),
                    );
                  },
                  childCount: restaurantData.length,
                ),
              ),
              
              // Bottom Spacing
              SliverToBoxAdapter(
                child: SizedBox(height: Responsive.h20px),
              ),
            ],
          ),
        ),
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


List<String> bannerImages=[
  'lib/assets/images/banners/b1.jpg',
  'lib/assets/images/banners/b3.jpg',
  'lib/assets/images/banners/b4.jpg',
  'lib/assets/images/banners/b5.jpg',

];

