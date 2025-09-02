import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/FlexibleSpaceBarHeader.dart';
import 'package:spicy_eats/SyncTabBar/HeaderSliver.dart';
import 'package:spicy_eats/SyncTabBar/MyHeader.dart';
import 'package:spicy_eats/SyncTabBar/SecondHeaderTitle.dart';
import 'package:spicy_eats/SyncTabBar/SliverBodyItems.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/SyncTabBar/headerTitle.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/features/Basket/model/basketModel.dart';
import 'package:spicy_eats/features/Basket/screens/basket.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

var showCartButton = StateProvider<bool>((ref) => false);
//var productProvider = StateProvider<DishData?>((ref) => null);
var cartList = StateProvider<List<BasketModel>>((ref) => []);
var cartLength = StateProvider<int?>((ref) => null);
final globalOffsetValues = ValueNotifier<double>(0);
//value to do the validations of the top icons
final valueScroll2 = ValueNotifier<double>(0);
final headerNotifier =
    ValueNotifier<MyHeader>(const MyHeader(index: 0, visible: false));

class HomeSliverWithScrollableTabs extends ConsumerStatefulWidget {
  static const String routename = '/homeSliver_screen';
  final String restuid;
  final RestaurantModel? restaurantdata;
  const HomeSliverWithScrollableTabs(
      {super.key, required this.restuid, required this.restaurantdata});

  @override
  ConsumerState<HomeSliverWithScrollableTabs> createState() =>
      _HomeSliverWithScrollableTabsState();
}

class _HomeSliverWithScrollableTabsState
    extends ConsumerState<HomeSliverWithScrollableTabs> {
  Future<List<Category>?> readjsoncategory() async {
    final response =
        await rootBundle.loadString('lib/assets/data/category.json');
    final List<dynamic> list = jsonDecode(response);
    return list.map((e) => Category.fromjson(e)).toList();
  }

  //to have overall controll of scrolling
  late ScrollController scrollControllerGlobally;

  List<Category> category = [];
  List<DishData> dishes = [];
  List<Categories> sections = [];
  Map<String, List<DishData>> sortedDishes = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollControllerGlobally = ScrollController();
    // readjsoncategory().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       category = value;
    //     });
    //   }
    //   scrollControllerGlobally.addListener(() {
    //     globalOffsetValues.value = scrollControllerGlobally.offset;
    //   });
    // });
    retrieveDishesAndCategoreis(widget.restuid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollControllerGlobally.dispose();
  }

  Future retrieveDishesAndCategoreis(String restuid) async {
    await ref
        .read(homeControllerProvider)
        .fetchDishes(restuid: restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          dishes = value;

          print(dishes[0].dish_name);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          List<ItemQuantity> newQuantityList = [];
          for (int i = 0; i < dishes.length; i++) {
            newQuantityList.add(ItemQuantity(id: dishes[i].dishid!));
            print('checking given dishData :: ${dishes[i].dishid}');
          }

          //Update quantityProvider state
          ref
              .read(quantityProvider.notifier)
              .update((state) => newQuantityList);
          //clear cart everytime
          ref.read(cartLength.notifier).state = 0;
          ref.read(cartList.notifier).state.clear();
          ref.read(showCartButton.notifier).state = false;
        });
      }
    });

    await ref
        .read(homeControllerProvider)
        .fetchCategories(restuid: restuid)
        .then((value) {
      if (value != null) {
        setState(() {
          sections = value;

          // for (int i = 0; i < sections.length; i++) {
          //   for (int j = 0; j < dishes.length; j++) {
          //     if (sections[i].category_id == dishes[j].category_id) {
          //       mydishes.add(dishes[j]);
          //     }
          //   }
          // sortedDishes[sections[i].category_id] = mydishes;

          // }
          sortedDishes.clear();
          for (var category in sections) {
            sortedDishes[category.category_id] = dishes
                .where((element) => element.category_id == category.category_id)
                .toList();
          }

          print(sections[0].category_name);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartlength = ref.watch(cartLength);

    void refreshHeader({
      required int index,
      required bool visible,
      required int? lastIndex,
    }) {
      final headerValue = headerNotifier.value;
      final headerTitle = headerValue.index;
      final headerVisible = headerValue.visible;

      // Only update the header if there’s a change in index or visibility
      if (headerTitle != index || headerVisible != visible) {
        print(
            'Inside primary condition - checking header update requirements.');

        Future.microtask(() {
          if (!visible) {
            // If the item is not visible and we're scrolling upwards, only reset to index 0
            // when scrolling reaches the top position (offset = 0).
            if (scrollControllerGlobally.offset <= 0) {
              headerNotifier.value = const MyHeader(visible: true, index: 0);
            } else if (lastIndex != null) {
              // Use the last known index when scrolling away but don't reset to zero unless necessary
              headerNotifier.value = MyHeader(visible: true, index: lastIndex);
            }
          } else {
            // Otherwise, set the header to the current index if it should be visible
            print('Inside visibility condition - updating index to: $index');
            headerNotifier.value = MyHeader(visible: visible, index: index);
          }
        });
      }
    }

    return Scaffold(
      // floatingActionButton: ref.watch(showCartButton)
      //     ? Align(
      //         alignment: Alignment.bottomCenter,
      //         child: SizedBox(
      //           height: 50,
      //           width: 150,
      //           child: FloatingActionButton(
      //             backgroundColor: Colors.black,
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10)),
      //             onPressed: () => Navigator.pushNamed(
      //                 context, BasketScreen.routename,
      //                 arguments: {
      //                   'dish': null,
      //                   'totalprice': 300.0,
      //                   'quantity': 12,
      //                   'cartlist': ref.read(cartList.notifier).state,
      //                   'dishes': dishes,
      //                 }),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 const Icon(
      //                   Icons.shopping_cart,
      //                   size: 30,
      //                   color: Colors.white,
      //                 ),
      //                 const SizedBox(
      //                   width: 10,
      //                 ),
      //                 Text(
      //                   '$cartlength',
      //                   style:
      //                       const TextStyle(fontSize: 28, color: Colors.white),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       )
      //     : const SizedBox(),
      body: Scrollbar(
        notificationPredicate: (scroll) {
          valueScroll2.value = scroll.metrics.extentInside;
          //print(scrollControllerGlobally.offset);
          return true;
        },
        radius: const Radius.circular(8),
        child: ValueListenableBuilder(
            valueListenable: globalOffsetValues,
            builder: (_, double valueCurrentScroll, __) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollControllerGlobally,
                slivers: [
                  FlexibleSpaceBarHeader(
                    restaurantdata: widget.restaurantdata,
                    valueScroll: valueCurrentScroll,
                  ),
                  SliverPersistentHeader(
                      //floating: true,
                      pinned: true,
                      delegate: HeaderSliver(
                          restauarantdata: widget.restaurantdata!,
                          listCategory: sections,
                          headernotifier: headerNotifier)),
                  for (int i = 0; i < sections.length; i++) ...[
                    SliverPersistentHeader(
                      delegate: MyHeaderTitle(
                        titles: sections,
                        index: i,
                        onHeaderChange: (visible) {
                          refreshHeader(
                              index: i,
                              visible: visible,
                              lastIndex: i > 0 ? i - 1 : null);
                        },
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: SecondHeaderTitle(
                        titles: sections,
                        index: i,
                        // onHeaderChange: (visible) {
                        //   refreshHeader(
                        //       index: i,
                        //       visible: visible,
                        //       lastIndex: i > 0 ? i - 1 : null);
                        // },
                      ),
                    ),
                    SliverBodyItems(
                      listItems: sortedDishes[sections[i].category_id] ?? [],
                    ),
                  ],
                  SliverList(
                      delegate: SliverChildBuilderDelegate(childCount: 1,
                          (BuildContext context, int index) {
                    return const SizedBox(height: 400);
                  })),
                ],
              );
            }),
      ),
    );
  }
}

//BackgroundSliver
class BackgroundSliver extends StatelessWidget {
  final RestaurantModel? restaurantdata;
  const BackgroundSliver({super.key, this.restaurantdata});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Background Image
        Positioned(
          top: 0,
          bottom: 50,
          left: 0,
          right: 0,
          child: Image.network(
            restaurantdata?.restaurantLogoImageUrl.toString() ??
                "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg", // Replace with your actual image URL
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.2),
          ),
        ),

        // Logo Positioned between the image and bottom bar
        Positioned(
          bottom:
              -0, // Adjust this value to move the logo slightly up or down as needed
          left: (size.width / 2) -
              50, // Adjust this value to horizontally center the logo
          child: Container(
            height: 100, // Adjust the height of the logo as needed
            width: 100, // Adjust the width of the logo as needed
            decoration: BoxDecoration(
              color: Colors.white, // White background for the logo's border
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 4), // Adjust the border thickness
            ),
            child: ClipOval(
              child: Image.network(
                restaurantdata?.restaurantLogoImageUrl.toString() ??
                    "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg", // Replace with the actual logo image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
