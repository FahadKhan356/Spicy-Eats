import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Home/repository/homerespository.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';

import 'package:spicy_eats/main.dart';

var titleVariationListProvider =
    StateProvider<List<VariattionTitleModel>?>((ref) => null);

class MyFinalScrollScreen extends ConsumerStatefulWidget {
  static const String routename = '/MyFinalScreen';
  final String? restuid;
  final RestaurantModel restaurantData;
  const MyFinalScrollScreen(
      {super.key, this.restuid, required this.restaurantData});

  @override
  ConsumerState<MyFinalScrollScreen> createState() =>
      _MyFinalScrollScreenState();
}

class _MyFinalScrollScreenState extends ConsumerState<MyFinalScrollScreen>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  double myOffset = 0.0;
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  // String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  bool isTabPinned = false;

  double _imageHeight = 200;
  double _imageOpacity = 1;
  double _titletabOpacity = 0;
  double _tabOpacity = 0;
  double _imageContainerRadius = 30;
  double _imageContainerSlide = 0.0;
  String? userId = supabaseClient.auth.currentUser!.id;
  bool cartFetched = false;
  List<VariattionTitleModel>? titleVariationList = [];

  Future fetchcategoriesAnddishes(String restuid) async {
    await ref
        .read(homeControllerProvider)
        .fetchDishes(restuid: restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          dishes = value;
        });
      }
    });
    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: restuid)
        .then((value) {
      if (value != null && mounted) {
        setState(() {
          allcategories = value;
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
        fetchcategoriesAnddishes(widget.restuid!).then((value) {
          if (allcategories.isNotEmpty) {
            setState(() {
              bloc.tabController =
                  TabController(length: allcategories.length, vsync: this);
              print('Number of tabs: ${bloc.tabs.length}');
              print('TabController length: ${bloc.tabController?.length}');
            });
          }

          bloc.init(this, dishes: dishes, categories: allcategories);
          bloc.scrollController!.addListener(() {
            updateOffset();
            // onScroll();
          });
        });
      }
    });

    ref.read(DummyLogicProvider).fetchCart(ref, userId!).then((value) {
      cartFetched = true;
      final cart = ref.read(cartProvider.notifier).state;
      if (cart.isNotEmpty) {
        print('${cart[0].tprice}');
      }
    });
  }

  void updateOffset() {
    double newImatgeHeight = (200 - myOffset).clamp(100, 200);
    double newImageOpacity = 1 - (myOffset / 100).clamp(0.1, 1);
    double newTitleTabOpacity = (myOffset > 200) ? 1.00 : 0.0;
    double newtabOpacity = (myOffset > 100) ? 1.0 : 0.0;
    double newContainerRadius = (300 - myOffset).clamp(10, 30);
    // double newContainerSlide = (300 - myOffset).clamp(10, 270);
    // double newContainerSlide = (myOffset / 300).clamp(0.0, 3);
    // Safely check if the scrollController is attached to the scroll view
    if (bloc.scrollController!.hasClients && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          myOffset = bloc.scrollController!.offset;

          // print('offset1 onscroll ${myOffset}');
          _imageHeight = newImatgeHeight;
          _imageOpacity = newImageOpacity;
          _titletabOpacity = newTitleTabOpacity;
          _tabOpacity = newtabOpacity;
          _imageContainerRadius = newContainerRadius;
          // _imageContainerSlide = newContainerSlide;

          // print("Scroll Offset: $myOffset");
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // bloc.tabController!.dispose();
    bloc.dispose();
    // bloc.scrollController!.dispose();
    // _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    // final size = MediaQuery.of(context).size;
    // final centeredOffset = (size.width / 150) - 2;
    return SafeArea(
      child: Scaffold(
          floatingActionButton: cart.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Container(
                      decoration: const BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black54,
                          //       blurRadius: 6,
                          //       offset: Offset(-1, -1),
                          //       spreadRadius: 1)
                          // ],
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      width: double.maxFinite,
                    ),
                  )

                  // FloatingActionButton(
                  //     backgroundColor: Colors.black,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Icon(
                  //           Icons.shopping_cart,
                  //           color: Colors.white,
                  //         ),
                  //         Text(
                  //           cart.length.toString(),
                  //           style: const TextStyle(color: Colors.white),
                  //         ), // Dynamic cart count
                  //       ],
                  //     ),
                  //     onPressed: () {
                  //       if (cartFetched) {
                  //         Navigator.pushNamed(context, DummyBasket.routename,
                  //             arguments: {
                  //               // 'cart': cart,
                  //               'dishes': dishes,
                  //               'restuid': widget.restuid,
                  //               'restdata': widget.restaurantData,
                  //             });
                  //         cartFetched = false;
                  //         ref.read(DummyLogicProvider).getTotalPrice(ref);
                  //       }
                  //     }),
                  )
              : const SizedBox(),
          backgroundColor: Colors.white, //Colors.white,
          body: allcategories.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: _imageHeight,
                          color: Colors.white,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _imageOpacity,
                            curve: Curves.easeIn,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              child: Image.network(
                                //'https://mrqaapzhzeqvarrtfkgv.supabase.co/storage/v1/object/public/Restaurant_Registeration//8d019a6b-b66a-466e-99b9-c66f9745ba70/Restaurant_covers',
                                widget.restaurantData.restaurantImageUrl
                                    .toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 210,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                height: 80,
                                width: double.maxFinite,
                                color: Colors.black26),
                          ),
                        )),
                    Positioned(
                      top: 0,
                      left: 10,
                      child: myOffset < 70
                          ? IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, HomeScreen.routename);
                              })
                          : const SizedBox(),
                    ),

                    AnimatedBuilder(
                        animation: bloc,
                        builder: (_, __) {
                          // print(size.width);
                          updateOffset();
                          return Positioned(
                            top: 40,
                            right: 0,
                            left: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _tabOpacity,
                              child: Container(
                                height: 60,
                                width: double.maxFinite,
                                child: TabBar(
                                    dividerColor: Colors.transparent,
                                    indicatorColor: Colors.transparent,
                                    onTap: bloc.onCategoryTab,
                                    isScrollable: true,
                                    controller: bloc.tabController,
                                    tabs: bloc.tabs
                                        .map((e) =>
                                            Rappi_tab_widget(category: e))
                                        .toList()),
                              ),
                            ),
                          );
                        }),
                    // const SizedBox(
                    //   height: 20,
                    // ),

                    Positioned.fill(
                      top: _imageHeight,
                      child: SingleChildScrollView(
                          controller: bloc.scrollController,
                          child: Column(children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                height: 122,
                                // color: Colors.amber,
                                child: Column(
                                  children: [
                                    Container(
                                      // height: 100,
                                      width: double.maxFinite,
                                      // color: Colors.black87,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                          Text(
                                            '20-40 mins |',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          RatingBar.builder(
                                            initialRating: 1.0,
                                            itemSize: 25,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) async {
                                              setState(() {
                                                ref
                                                    .read(
                                                        homeRepositoryController)
                                                    .addRatings(
                                                        context: context,
                                                        restid: widget
                                                            .restaurantData
                                                            .restuid!,
                                                        userid: supabaseClient
                                                            .auth
                                                            .currentUser!
                                                            .id,
                                                        ratings: rating);

                                                ref
                                                    .read(
                                                        homeRepositoryController)
                                                    .calculateAverageRatingsWithUpdate(
                                                        context: context,
                                                        restid:
                                                            widget.restuid!);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              height: 5,
                                              color: Colors.black26,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Menu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              height: 5,
                                              color: Colors.black26,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                )),
                            // GridView.builder(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 2,
                            //     ),
                            //     itemCount: bloc.items.length,
                            //     itemBuilder: (context, index) {
                            //       final items = bloc.items[index];
                            //       final cartIndex = cart.firstWhere(
                            //           (dish) =>
                            //               dish.dish_id ==
                            //               bloc.items[index].product?.dishid,
                            //           orElse: () => CartModelNew(
                            //               dish_id: 0, quantity: 0));
                            //       final quantityindex = cart.indexWhere(
                            //           (dish) =>
                            //               dish.dish_id ==
                            //               items.product?.dishid);

                            //       if (bloc.items[index].isCategory) {
                            //         return RappiCategory(
                            //             category: bloc.items[index].category);
                            //       } else {
                            //         return RappiProduct(
                            //           dish: bloc.items[index].product!,
                            //           cartItem: cartIndex,
                            //           qunatityindex: quantityindex,
                            //           userId:
                            //               supabaseClient.auth.currentUser!.id,
                            //           titleVariationList: titleVariationList,
                            //           // variattionTitle: titleVariation,
                            //         );
                            //       }
                            //     }),
                            ...List.generate(bloc.items.length, (index) {
                              // final titleVariation =
                              //     titleVariationList!.firstWhere(
                              //   (v) => v.dishid == bloc.items[index].product,
                              //   orElse: () => VariattionTitleModel(
                              //       id: null,
                              //       variationTitle: '',
                              //       isRequired: null,
                              //       variations: [],
                              //       maxSeleted: null,
                              //       dishid: null),
                              // );

                              final items = bloc.items[index];
                              final cartIndex = cart.firstWhere(
                                  (dish) =>
                                      dish.dish_id ==
                                      bloc.items[index].product?.dishid,
                                  orElse: () =>
                                      CartModelNew(dish_id: 0, quantity: 0));
                              final quantityindex = cart.indexWhere((dish) =>
                                  dish.dish_id == items.product?.dishid);

                              if (bloc.items[index].isCategory) {
                                return RappiCategory(
                                    category: bloc.items[index].category);
                              } else {
                                return RappiProduct(
                                  restaurantData: widget.restaurantData,
                                  dishes: dishes,
                                  dish: bloc.items[index].product!,
                                  cartItem: cartIndex,
                                  qunatityindex: quantityindex,
                                  userId: supabaseClient.auth.currentUser!.id,
                                  titleVariationList: titleVariationList,
                                  // variattionTitle: titleVariation,
                                );
                              }
                            }),
                          ])),
                    ),

                    Positioned(
                      top: 0,
                      left: 5,
                      child: AnimatedOpacity(
                        curve: Curves.bounceIn,
                        opacity: myOffset >= 110 ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: IconButton(
                            onPressed: () => Navigator.pushNamed(
                                context, HomeScreen.routename),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 25,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Positioned(
                      top: myOffset >= 100
                          ? _imageHeight - 90
                          : _imageHeight - 145,
                      left: myOffset >= 110
                          ? (MediaQuery.of(context).size.width - 80) / 1
                          : (MediaQuery.of(context).size.width - 60) / 5,
                      child: AnimatedSlide(
                        offset: Offset(myOffset >= 110 ? -4.2 : 0, 0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                        child: Text(
                          'AlBaiq',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: myOffset >= 110
                                  ? Colors.black
                                  : Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
