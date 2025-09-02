import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/BasketScreen.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Basket/repository/CartRepository.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/sliverTabBar.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';
import 'package:spicy_eats/main.dart';

var restaurantProvider = StateProvider<RestaurantModel?>((ref) => null);

class RestaurantMenuScreen extends ConsumerStatefulWidget {
  static const String routename = 'RestaurantMenuScreen/';
  final bool? initTab;
  final RestaurantModel restaurantData;
  const RestaurantMenuScreen({
    super.key,
    this.initTab,
    required this.restaurantData,
  });

  @override
  ConsumerState<RestaurantMenuScreen> createState() =>
      _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends ConsumerState<RestaurantMenuScreen>
    with TickerProviderStateMixin {
  // final bloc = RappiBloc();
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  List<VariattionTitleModel>? titleVariationList = [];
  bool showTabBar = false;
  bool isTabControllerReady = false; // Track initialization
  bool cartFetched = false;
  final userId = supabaseClient.auth.currentUser!.id;
  bool isloader = true;

  Future<void> initTab() async {
    final notifier = ref.read(restaurantScrollProvider);

    if (notifier.tabController?.length != notifier.tabs.length) {
      notifier.tabController?.dispose();
      notifier.tabController = null;
    }

    notifier.tabController =
        TabController(length: allcategories.length, vsync: this);
  }

  Future fetchcategoriesAnddishes(String restuid) async {
    setState(() {
      isloader = true;
    });

    await ref
        .read(homeControllerProvider)
        .getDishesData(widget.restaurantData.restuid!)
        .then((value) {
      setState(() {
        dishes = value;
      });
      ref.read(restaurantProvider.notifier).state = widget.restaurantData;
      ref.read(dishesListProvider.notifier).state = value;
    });
    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: widget.restaurantData.restuid!)
        .then((value) {
      if (value != null) {
        setState(() {
          allcategories = value.cast<Categories>();
          print(allcategories[0].category_name);
        });
      }
    });

    ref
        .read(restaurantScrollProvider)
        .init(this, dishes: dishes, categories: allcategories);
    ref.read(restaurantScrollProvider).scrollController!.addListener(() {
      _scrollListener();
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final notifier = ref.read(restaurantScrollProvider);

        await fetchcategoriesAnddishes(widget.restaurantData.restuid!);
        setState(() {
          isloader = false;
        });
        // if (notifier.tabController?.length != notifier.tabs.length ) {
        //   notifier.tabController?.dispose();
        //   notifier.tabController = null;
        //   debugPrint('done null to tabcontroller');
        // }

        // notifier.tabController =
        //     TabController(length: allcategories.length, vsync: this);
        // debugPrint('tabcontroller to ${allcategories.length}');
        // // initTab();
        setState(() {
          isTabControllerReady = true;
        });
      }
    });

    ref.read(cartReopProvider).initializeCart(userId: userId, ref: ref);
  }

  void _scrollListener() {
    double offset = ref.read(restaurantScrollProvider).scrollController!.offset;
    double triggerOffset = 180; // Change based on your UI

    if (offset >= triggerOffset && !showTabBar) {
      setState(() {
        showTabBar = true;
      });
    } else if (offset < triggerOffset && showTabBar) {
      setState(() {
        showTabBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(restaurantScrollProvider);
    final isfav =
        ref.watch(favoriteProvider)[widget.restaurantData.restuid] ?? false;
    final cart = ref.watch(cartProvider);
    return Scaffold(
      floatingActionButton: cart.isEmpty
          ? const SizedBox()
          : Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        cart.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ), // Dynamic cart count
                    ],
                  ),
                  onPressed: () {
                    ref.read(isloaderProvider.notifier).state = true;
                    Navigator.pushNamed(context, BasketScreen.routename,
                        arguments: {
                          // 'cart': cart,
                          'dishes': dishes,
                          'restuid': widget.restaurantData.restuid,
                          'restdata': widget.restaurantData,
                        });
                    cartFetched = false;
                    ref.read(cartReopProvider).getTotalPrice(ref);
                    // }
                  }),
            ),
      backgroundColor: Colors.white,
      body: Skeletonizer(
        enabled: isloader,
        enableSwitchAnimation: true,
        child: CustomScrollView(
          controller: ref.read(restaurantScrollProvider).scrollController,
          slivers: [
            SliverAppBar(
              leadingWidth: 70,
              // stretch: true,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  splashColor: Colors.orange,
                  // highlightColor: Colors.red,
                  onTap: () => Navigator.pushNamed(context, Home.routename),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      height: 50,
                      width: 50,
                      // color: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10.0),
                  child: InkWell(
                    hoverColor: Colors.red,
                    onTap: () => ref
                        .read(registershoprepoProvider)
                        .togglefavorites(
                            userid: supabaseClient.auth.currentUser!.id,
                            restid: widget.restaurantData.restuid!,
                            ref: ref,
                            context: context),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      height: 50,
                      width: 50,
                      child: isfav
                          ? Icon(
                              Icons.favorite,
                              size: 22,
                              color: Colors.orange[900],
                            )
                          : const Icon(
                              Icons.favorite_outline_sharp,
                              size: 22,
                              color: Colors.black,
                            ),
                    ),
                  ),
                )
              ],
              elevation: 10,
              surfaceTintColor: Colors.white,
              pinned: true,
              expandedHeight: 250,
              collapsedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16, top: 10),
                title: SizedBox(
                    height: 60, // 👈 fixed height for the title area
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: showTabBar
                          ? Column(
                              key: const ValueKey('withTitle'),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.restaurantData.restaurantName!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      initialRating: widget
                                          .restaurantData.averageRatings!
                                          .toDouble(),
                                      itemSize: 15,
                                      itemCount: 5,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        size: 22,
                                      ),
                                      onRatingUpdate: (_) {},
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.restaurantData.averageRatings}',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 7,
                                      width: 7,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(3.5),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.restaurantData.totalRatings} Ratings',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),

                      // ? Center(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           '${widget.restaurantData.restaurantName}',
                      //           style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         Center(
                      //           child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               children: [
                      //                 RatingBar.builder(
                      //                     ignoreGestures: true,
                      //                     allowHalfRating: true,
                      //                     initialRating: widget
                      //                         .restaurantData.averageRatings!
                      //                         .toDouble(),
                      //                     itemSize: 15,
                      //                     itemCount: 5,
                      //                     itemBuilder: (context, index) =>
                      //                         const Icon(
                      //                           Icons.star,
                      //                           size: 22,
                      //                         ),
                      //                     onRatingUpdate: (double) {}),
                      //                 const SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   '${widget.restaurantData.averageRatings}',
                      //                   style: const TextStyle(
                      //                       color: Colors.black, fontSize: 15),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 ClipRRect(
                      //                   borderRadius: BorderRadius.circular(3.5),
                      //                   child: Center(
                      //                       child: Container(
                      //                     height: 7,
                      //                     width: 7,
                      //                     color: Colors.black,
                      //                   )),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   '${widget.restaurantData.totalRatings} Ratings',
                      //                   style: const TextStyle(
                      //                       color: Colors.black, fontSize: 15),
                      //                 ),
                      //               ]
                      //               //  List.generate(
                      //               //   5,
                      //               //   (index) => Icon(
                      //               //     Icons.star,
                      //               //     size: 22,
                      //               //   ),
                      //               // )

                      //               ),
                      //         )
                      //       ],
                      //     ),
                      //   )
                    )),
                background: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.restaurantData.restaurantImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            !isTabControllerReady ||
                    notifier.tabController == null ||
                    notifier.tabController?.length != notifier.tabs.length
                ? SliverToBoxAdapter(
                    child: Text(
                        ' notifier controller length : ${notifier.tabController?.length} tabs length : ${notifier.tabs.length} '))
                : SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverTabBar(
                      isshowtabbar: showTabBar,
                      isTabControllerReady: isTabControllerReady,
                      bloc: notifier,
                    ),
                  ),
            // : const SliverToBoxAdapter(child: SizedBox()),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            // child: Container(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //   width: double.maxFinite,
            //   height: 80,

            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border.all(color: Colors.black12, width: 1.5),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   //const Color.fromRGBO(209, 209, 209, 1),
            //   //Color.fromARGB(255, 247, 208, 158).withOpacity(0.2),
            //   child: Row(
            //     children: [
            //       Container(
            //         height: 60,
            //         width: 60,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(color: Colors.black12, width: 1.5),
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: const Icon(
            //           Icons.electric_bike_sharp,
            //           size: 30,
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       Expanded(
            //         child: Container(
            //           height: 70,
            //           width: 60,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             border:
            //                 Border.all(color: Colors.black12, width: 1.5),
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 ' Delivery : ${widget.restaurantData.minTime} - ${widget.restaurantData.maxTime} ',
            //                 style: const TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               Text(
            //                 'Delivery Fee : \$${widget.restaurantData.deliveryFee}',
            //                 style: const TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.black),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            //   ),
            // ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    childCount: ref.read(restaurantScrollProvider).items.length,
                    (context, index) {
              final cartIndex = cart.firstWhere(
                  (dish) =>
                      dish.dish_id ==
                      ref
                          .read(restaurantScrollProvider)
                          .items[index]
                          .product
                          ?.dishid,
                  orElse: () =>
                      Cartmodel(created_at: '', dish_id: 0, quantity: 0));
              if (ref.read(restaurantScrollProvider).items[index].isCategory) {
                return RappiCategory(
                    category: ref
                        .read(restaurantScrollProvider)
                        .items[index]
                        .category);
              } else {
                return RappiProduct(
                  restaurantData: widget.restaurantData,
                  dishes: dishes,
                  dish:
                      ref.read(restaurantScrollProvider).items[index].product!,
                  cartItem: cartIndex,
                  // qunatityindex: quantityindex,
                  userId: supabaseClient.auth.currentUser!.id,
                  titleVariationList: titleVariationList,
                  // variattionTitle: titleVariation,
                );
              }
            }))
          ],
        ),
      ),
    );
  }
}
