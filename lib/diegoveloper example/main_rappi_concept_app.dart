import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';

class Mian_rappi_concept_app extends ConsumerStatefulWidget {
  const Mian_rappi_concept_app({super.key});

  @override
  ConsumerState<Mian_rappi_concept_app> createState() =>
      _Mian_rappi_concept_appState();
}

// TabController? _tabController;

class _Mian_rappi_concept_appState extends ConsumerState<Mian_rappi_concept_app>
    with TickerProviderStateMixin {
  final bloc = RappiBloc();
  double myOffset = 0.0;
  List<DishData> dishes = [];
  List<Categories> allcategories = [];
  String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  bool isTabPinned = false;
  late AnimationController _opacityController;
  late Animation _opacityAnimation;
  double _imageHeight = 300;
  double _imageOpacity = 1;
  double _titletabOpacity = 0;

  void onScroll() {
    bloc.scrollController = ScrollController();
    // double offset1 = bloc.scrollController!.offset;
    double newImatgeHeight = (300 - myOffset).clamp(150, 300);
    double newImageOpacity = 1 - (myOffset / 100).clamp(0.3, 1);
    double newTitleTabOpacity = (myOffset > 200) ? 1.00 : 0.0;

    if (bloc.scrollController!.hasClients) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _imageHeight = newImatgeHeight;
            _imageOpacity = newImageOpacity;
            _titletabOpacity = newTitleTabOpacity;
          });
        });
      }
    }
  }

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
      if (value != null) {
        setState(() {
          allcategories = value;
          print(allcategories[0].category_name);
        });
      }
    });
  }

  @override
  void initState() {
    _opacityController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _opacityController, curve: Curves.easeIn));
    // TODO: implement initState
    super.initState();

    fetchcategoriesAnddishes(restuid).then((value) {
      if (allcategories.isNotEmpty) {
        setState(() {
          bloc.tabController =
              TabController(length: allcategories.length, vsync: this);
          print('Number of tabs: ${bloc.tabs.length}');
          print('TabController length: ${bloc.tabController?.length}');
          // bloc.tabController =
          //     TabController(length: bloc.tabs.length, vsync: this);
        });
      }

      bloc.init(this, dishes: dishes, categories: allcategories);
    });

    bloc.scrollController = ScrollController();
    bloc.scrollController!.addListener(() {
      updateOffset();
      onScroll();
    }); // Update the offset when scrolling
  }

  void updateOffset() {
    // Safely check if the scrollController is attached to the scroll view
    if (bloc.scrollController!.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            myOffset = bloc.scrollController!.offset;
            print("Scroll Offset: $myOffset");
          });
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.tabController!.dispose();
    bloc.dispose();
    bloc.scrollController!.dispose();
    _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return allcategories.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: AnimatedBuilder(
                  animation: bloc,
                  builder: (_, __) {
                    updateOffset();
                    return Column(
                      children: [
                        // Container(
                        //   color: Colors.white,
                        //   height: 100,
                        //   width: double.maxFinite,
                        //   child: Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       const Text(
                        //         "Home Screen",
                        //         style: TextStyle(
                        //             fontSize: 20, color: Colors.black),
                        //       ),
                        //       Container(
                        //         height: 40,
                        //         width: 40,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(25),
                        //             border: Border.all(
                        //                 color: Colors.black12, width: 2)),
                        //         child: CircleAvatar(
                        //           backgroundColor: Colors.black87,
                        //           child: ClipOval(
                        //             child: Image.network(
                        //               "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        myOffset >= 90
                            ? AnimatedOpacity(
                                curve: Curves.linear,
                                duration: const Duration(milliseconds: 400),
                                opacity: myOffset >= 120 ? 1 : 0,
                                child: Container(
                                  height: 60,
                                  width: double.maxFinite,
                                  color: Colors.white,
                                  child: TabBar(
                                    indicatorColor: Colors.white,
                                    isScrollable: true,
                                    controller: bloc.tabController,
                                    tabs: bloc.tabs.map((e) {
                                      return Rappi_tab_widget(category: e);
                                    }).toList(),
                                    //bloc.tabs.map((e) => Rappi_tab_widget(category: e)).toList()
                                    onTap: bloc.onCategoryTab,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        //
                        Expanded(
                          child: SingleChildScrollView(
                            controller: bloc.scrollController,
                            child: Container(
                                // width: double.maxFinite,
                                color: Colors.white,
                                child: Column(children: [
                                  AnimatedOpacity(
                                      opacity: myOffset <= 90 ? 1 : 0,
                                      duration:
                                          const Duration(microseconds: 400),
                                      curve: Curves.easeIn,
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.black,
                                            height: 120,
                                            width: double.maxFinite,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Home Screen",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      border: Border.all(
                                                          color: Colors.black12,
                                                          width: 2)),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black87,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),

                                  ...List.generate(bloc.items.length, (index) {
                                    if (bloc.items[index].isCategory) {
                                      return RappiCategory(
                                          category: bloc.items[index].category);
                                    } else {
                                      return RappiProduct(
                                        dish: bloc.items[index].product!,
                                      );
                                    }
                                  }),
                                  // SizedBox(
                                  //     height:
                                  //         MediaQuery.of(context).size.height),
                                ])),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
  }
}

Widget Rappi_tab_widget({RapitabCategory? category}) {
  return Card(
    margin: const EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    borderOnForeground: false,
    color: category!.selected! ? Colors.white : Colors.black,
    elevation: category.selected! ? 6 : 0,
    shadowColor: Colors.black12,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        category.category.category_name.toString(),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: category.selected! ? Colors.black : Colors.white),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
class RappiCategory extends StatelessWidget {
  RappiCategory({required this.category});
  final Categories? category;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        width: double.maxFinite,
        child: Card(
            elevation: 0,
            color: Colors.white,
            child: Center(
              child: Text(
                category!.category_name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )));
  }
}

// ignore: non_constant_identifier_names
class RappiProduct extends ConsumerWidget {
  RappiProduct(
      {required this.dish, this.cartItem, this.qunatityindex, this.userId});
  final DishData dish;
  final CartModelNew? cartItem;
  final int? qunatityindex;
  final String? userId;
  @override
  Widget build(BuildContext context, WidgetRef? ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          height: 130,
          width: double.maxFinite,
          child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              color: Colors.white,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          // color: Colors.red,
                          height: 120,
                          width: 120,
                          child: Image.network(
                            dish.dish_imageurl.toString(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            // color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dish.dish_name.toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                Text(
                                  dish.dish_description.toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${dish.dish_price!.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: Container(
                      // color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          cartItem!.dish_id != dish.dishid
                              ? InkWell(
                                  onTap: () {
                                    ref?.read(DummyLogicProvider).addToCart(
                                          ref,
                                          userId!,
                                          dish.dishid.toString(),
                                          dish.dish_price!.toDouble(),
                                          dish.dish_imageurl!,
                                        );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                ?.read(DummyLogicProvider)
                                                .increaseQuantity(
                                                  ref,
                                                  dish.dishid!,
                                                  dish.dish_price!,
                                                );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: const Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 50,
                                        //   width: 50,
                                        //   child: ElevatedButton(
                                        //     onPressed: () {
                                        //       ref
                                        //           ?.read(DummyLogicProvider)
                                        //           .increaseQuantity(
                                        //               ref, dish.dishid!);
                                        //     },
                                        //     style: ElevatedButton.styleFrom(
                                        //       shape: const RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.only(
                                        //             topRight: Radius.circular(10),
                                        //             bottomLeft:
                                        //                 Radius.circular(10)),
                                        //         side: BorderSide(
                                        //             width: 2,
                                        //             color: Colors.black),
                                        //       ),
                                        //     ),
                                        //     child: Center(
                                        //         child: const Icon(Icons.add)),
                                        //   ),
                                        // ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        //cartItem.quantity.toString(),
                                        ref!
                                            .read(cartProvider.notifier)
                                            .state[qunatityindex!]
                                            .quantity
                                            .toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(DummyLogicProvider)
                                                .decreaseQuantity(
                                                  ref,
                                                  dish.dishid!,
                                                  dish.dish_price!,
                                                );
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.minimize_outlined,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          // ),SizedBox(
                                          //   height: 50,
                                          //   width: 50,
                                          //   child: ElevatedButton(
                                          //     onPressed: () {
                                          //       ref
                                          //           .read(DummyLogicProvider)
                                          //           .decreaseQuantity(
                                          //               ref, dish.dishid!);
                                          //     },
                                          //     style: ElevatedButton.styleFrom(
                                          //       alignment: Alignment.center,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.only(
                                          //             bottomRight:
                                          //                 Radius.circular(10),
                                          //             topLeft: Radius.circular(10)),
                                          //         side: const BorderSide(
                                          //             width: 2,
                                          //             color: Colors.black),
                                          //       ),
                                          //     ),
                                          //     child: Center(
                                          //         child: const Icon(Icons.remove)),
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
