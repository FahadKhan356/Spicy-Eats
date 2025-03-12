import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';

import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

class RestaurantMenuScreen extends ConsumerStatefulWidget {
  static const String routename = 'RestaurantMenuScreen/';
  final String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  RestaurantData restaurantData;
  RestaurantMenuScreen({
    super.key,
    required this.restaurantData,
  });

  @override
  ConsumerState<RestaurantMenuScreen> createState() =>
      _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends ConsumerState<RestaurantMenuScreen>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  List<VariattionTitleModel>? titleVariationList = [];
  bool showTabBar = false;
  bool isTabControllerReady = false; // Track initialization
  Future fetchcategoriesAnddishes(String restuid) async {
    await ref
        .read(homeControllerProvider)
        .fetchDishes(restuid: widget.restaurantData.restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          dishes = value;
        });
      }
    });
    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: widget.restaurantData.restuid!)
        .then((value) {
      if (value != null && mounted) {
        setState(() {
          allcategories = value.cast<Categories>();
          print(allcategories[0].category_name);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchcategoriesAnddishes(widget.restaurantData.restuid!).then((value) {
          if (allcategories.isNotEmpty) {
            setState(() {
              // bloc.tabController =
              //     TabController(length: allcategories.length, vsync: this);
              // print('Number of tabs: ${bloc.tabs.length}');
              // print('TabController length: ${bloc.tabController?.length}');
              // Initialize TabController once categories are fetched
              bloc.tabController =
                  TabController(length: allcategories.length, vsync: this);

              isTabControllerReady = true; // Mark as ready
            });
          }

          bloc.init(this, dishes: dishes, categories: allcategories);
          bloc.scrollController!.addListener(() {
            _scrollListener();
          });
        });
      }
    });

    // ref.read(DummyLogicProvider).fetchCart(ref, userId!).then((value) {
    //   cartFetched = true;
    //   final cart = ref.read(cartProvider.notifier).state;
    //   if (cart.isNotEmpty) {
    //     print('${cart[0].tprice}');
    // }
    // });
  }

  void _scrollListener() {
    double offset = bloc.scrollController!.offset;
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
    final cart = ref.watch(cartProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: bloc.scrollController,
        slivers: [
          SliverAppBar(
            stretch: true,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 30,
                  width: 30,
                  color: Colors.white,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.white,
                    child: const Icon(
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
              titlePadding: EdgeInsets.only(bottom: 16, top: 10),
              title: showTabBar
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Albaik',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RatingBar.builder(
                                      initialRating: 4,
                                      itemSize: 15,
                                      itemCount: 5,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                            Icons.star,
                                            size: 22,
                                          ),
                                      onRatingUpdate: (double) {}),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    '4.0',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3.5),
                                    child: Center(
                                        child: Container(
                                      height: 7,
                                      width: 7,
                                      color: Colors.black,
                                    )),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    '1000+ Ratings',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ]
                                //  List.generate(
                                //   5,
                                //   (index) => Icon(
                                //     Icons.star,
                                //     size: 22,
                                //   ),
                                // )

                                ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: Image.network(
                  widget.restaurantData.restaurantImageUrl!,
                  // 'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          isTabControllerReady
              ? SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBar(
                    isTabControllerReady: isTabControllerReady,
                    bloc: bloc,
                  ),
                )
              : const SliverToBoxAdapter(child: SizedBox()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: double.maxFinite,
                    height: 80,
                    color: Colors.black,
                    //const Color.fromRGBO(209, 209, 209, 1),
                    //Color.fromARGB(255, 247, 208, 158).withOpacity(0.2),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            width: 60,
                            color: Colors.white,
                            child: const Icon(
                              Icons.electric_bike_sharp,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 70,
                              width: 60,
                              color: Colors.white,
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Delivery : 5-20 min',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Delivery Fee : \$2.5',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: bloc.items.length, (context, index) {
            final cartIndex = cart.firstWhere(
                (dish) => dish.dish_id == bloc.items[index].product?.dishid,
                orElse: () => CartModelNew(dish_id: 0, quantity: 0));
            if (bloc.items[index].isCategory) {
              return RappiCategory(category: bloc.items[index].category);
            } else {
              return RappiProduct(
                dish: bloc.items[index].product!,
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
    );
  }
}

const double headertitle = 60;

class _SliverTabBar extends SliverPersistentHeaderDelegate {
  RappiBloc bloc;
  bool isTabControllerReady;
  _SliverTabBar({required this.bloc, required this.isTabControllerReady});

  @override
  // TODO: implement maxExtent
  double get maxExtent => headertitle;

  @override
  // TODO: implement minExtent
  double get minExtent => headertitle;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: headertitle,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 2.0),
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5)
          ],
          // border: Border.symmetric(
          //     horizontal: BorderSide(width: 5, color: Colors.black87)),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            // bottomLeft: Radius.circular(10),
            // bottomRight: Radius.circular(10)
          )),
      child: AnimatedBuilder(
          animation: bloc,
          builder: (_, __) {
            return TabBar(
              tabs:
                  bloc.tabs.map((e) => Rappi_tab_widget(category: e)).toList(),
              padding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              onTap: (index) => bloc.onCategoryTab(index),
              isScrollable: true,
              controller: bloc.tabController,
            );
          }),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
