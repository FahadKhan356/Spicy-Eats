import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/commons/CartCard.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVariation.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/features/dish%20menu/repository/dishmenu_repo.dart';

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
  RestaurantModel? restaurantData;
  List<Categories> allcategories = [];
  String restuid = 'd20a2270-b19b-462c-8a65-ba13ff8c0197';
  bool isTabPinned = false;
  late AnimationController _opacityController;
  late Animation _opacityAnimation;
  double _imageHeight = 300;
  double _imageOpacity = 1;
  double _titletabOpacity = 0;
  Debouncer? _debouncer;
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            bloc.tabController =
                TabController(length: allcategories.length, vsync: this);
            print('Number of tabs: ${bloc.tabs.length}');
            print('TabController length: ${bloc.tabController?.length}');
            // bloc.tabController =
            //     TabController(length: bloc.tabs.length, vsync: this);
          });
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
                                        restaurantData: restaurantData,
                                        dishes: dishes,
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

class Rappi_tab_widget extends StatefulWidget {
  RapitabCategory? category;
  Rappi_tab_widget({super.key, required this.category});

  @override
  State<Rappi_tab_widget> createState() => _Rapp_tab_widgetState();
}

class _Rapp_tab_widgetState extends State<Rappi_tab_widget> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.category!.selected ?? false;
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      borderOnForeground: false,
      color: isSelected ? Colors.black : Colors.white,
      elevation: isSelected ? 6 : 0,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.category!.category.category_name.toString(),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
//  Rappi_tab_widget({RapitabCategory? category}) {
//   return Card(
//     margin: const EdgeInsets.all(5),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     borderOnForeground: false,
//     color: category!.selected! ? Colors.black : Colors.white,
//     elevation: category.selected! ? 6 : 0,
//     shadowColor: Colors.black12,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         category.category.category_name.toString(),
//         style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: category.selected! ? Colors.white : Colors.black),
//       ),
//     ),
//   );
// }

// ignore: non_constant_identifier_names
class RappiCategory extends StatelessWidget {
  RappiCategory({required this.category});
  final Categories? category;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        height: 65,
        width: double.maxFinite,
        child: Card(
            elevation: 0,
            color: Colors.white,
            child: Center(
              child: Text(
                category!.category_name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )));
  }
}

// ignore: non_constant_identifier_names
class RappiProduct extends ConsumerStatefulWidget {
  RappiProduct({
    required this.dishes,
    required this.dish,
    this.cartItem,
    this.qunatityindex,
    this.userId,
    this.titleVariationList,
    // this.variattionTitle
    required this.restaurantData,
  });
  List<DishData> dishes = [];
  final DishData dish;
  final CartModelNew? cartItem;
  final int? qunatityindex;
  final String? userId;
  List<VariattionTitleModel>? titleVariationList;
  RestaurantModel? restaurantData;
  // VariattionTitleModel? variattionTitle;

  @override
  ConsumerState<RappiProduct> createState() => _RappiProductState();
}

class _RappiProductState extends ConsumerState<RappiProduct> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        widget.dish.isVariation
            ? Navigator.pushNamed(context, DishMenuVariation.routename,
                arguments: {
                    'dishes': widget.dishes,
                    'dish': widget.dish,
                    'iscart': false,
                    'cartdish': widget.cartItem,
                    'isbasket': false,
                    'restaurantdata': widget.restaurantData,
                    'isdishscreen': true,
                  })
            : Navigator.pushNamed(context, DishMenuScreen.routename,
                arguments: {
                    'dish': widget.dish,
                    'iscart': false,
                    'cartdish': widget.cartItem,
                    'isbasket': false,
                    'isdishscreen': true,
                  });
      },
      child: CartCard(
        elevation: 0,
        cardColor: null,
        dish: widget.dish,
        imageHeight: 120,
        imageWidth: 120,
        cartItem: widget.cartItem!,
        userId: widget.userId,
        addbuttonHeight: 40,
        buttonIncDecHeight: 40,
        buttonIncDecWidth: 40,
        quantityIndex: widget.qunatityindex,
        titleVariationList: widget.titleVariationList,
      ),
    );
  }
}
