import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/MyHeader.dart';
import 'package:spicy_eats/SyncTabBar/SecondHeaderTitle.dart';
import 'package:spicy_eats/SyncTabBar/Sliver_Scroll_controller.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/SyncTabBar/headerTitle.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/features/Home/controller/homecontroller.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';

final globalOffsetValues = ValueNotifier<double>(0);
//value to do the validations of the top icons
final valueScroll2 = ValueNotifier<double>(0);
final headerNotifier =
    ValueNotifier<MyHeader>(const MyHeader(index: 0, visible: false));

class HomeSliverWithScrollableTabs extends ConsumerStatefulWidget {
  static const String routename = '/homeSliver_screen';
  final String restuid;
  final RestaurantData? restaurantdata;
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
  List<DishData> mydishes = [];

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
              headerNotifier.value = MyHeader(visible: true, index: 0);
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

class FlexibleSpaceBarHeader extends StatelessWidget {
  final RestaurantData? restaurantdata;
  FlexibleSpaceBarHeader(
      {super.key, required this.valueScroll, this.restaurantdata});
  final double valueScroll;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      stretch: true,
      pinned: valueScroll > 90 ? true : false,
      expandedHeight: 280,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundSliver(
              restaurantdata: restaurantdata,
            ),
            Positioned(
                top: 20, //(size.height - 10),
                right: 10,
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                )),
            Positioned(
                top: 20, //(size.height - 30),
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                )),
          ],
        ),
      ),
    );
  }
}

//BackgroundSliver
class BackgroundSliver extends StatelessWidget {
  RestaurantData? restaurantdata;
  BackgroundSliver({super.key, this.restaurantdata});

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

//HeaderSliver
const _maxHeaderExtent = 100.0;

class HeaderSliver extends SliverPersistentHeaderDelegate {
  HeaderSliver(
      {required this.listCategory,
      required this.headernotifier,
      required this.restauarantdata});

  List<Categories> listCategory;
  final RestaurantData restauarantdata;
  final headernotifier;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final centeredOffset = (size.width / 150) - 2;
    final percent = shrinkOffset / _maxHeaderExtent;
    final currentIndex = (shrinkOffset / _maxHeaderExtent).floor();
    if (currentIndex < listCategory.length) {
      // headernotifier.value = MyHeader(visible: true, index: currentIndex);
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: percent > 0.1 ? Colors.black : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                          opacity: percent > 0.1 ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      AnimatedSlide(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300),
                          offset: Offset(
                              percent < 0.1
                                  ? centeredOffset / size.width + 3.4
                                  : 0.1,
                              0),
                          //Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                          child: Text(
                            restauarantdata.restaurantName!,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color:
                                  percent > 0.1 ? Colors.white : Colors.black,
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: percent > 0.1
                        ? ListItemHeaderSliver(
                            listCategory: listCategory,
                            HeaderNotifier: headernotifier,
                          )
                        : SliverHeaderData(
                            restaurantdata: restauarantdata,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (percent > 0.1)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeOutQuint,
                duration: Duration(milliseconds: 600),
                child: percent > 0.1
                    ? Container(
                        height: 2,
                        color: Colors.black,
                      )
                    : null,
              ))
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxHeaderExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class SliverHeaderData extends StatelessWidget {
  SliverHeaderData({
    required this.restaurantdata,
  });

  final RestaurantData restaurantdata;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   'Asiatisch , koreanisch , Japanisch',
          //   style: TextStyle(fontSize: 14),
          // ),
          SizedBox(
            height: 6,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time),
                SizedBox(
                  width: 4,
                ),
                Text(
                    '${restaurantdata.maxTime} - ${restaurantdata.minTime} Min | ${restaurantdata.ratings}',
                    style: TextStyle(fontSize: 15)),
                SizedBox(
                  width: 6,
                ),
                Icon(
                  Icons.star,
                  size: 14,
                ),
                SizedBox(
                  width: 6,
                ),
                Text('\$6.5 fee', style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SliverBodyItems extends ConsumerStatefulWidget {
  SliverBodyItems({super.key, required this.listItems});

  //List<Product> listItems;
  final List<DishData> listItems;

  @override
  ConsumerState<SliverBodyItems> createState() => _SliverBodyItemsState();
}

class _SliverBodyItemsState extends ConsumerState<SliverBodyItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // addDishestoItemQuantity();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addDishestoItemQuantity();
    // });
  }

  // void addDishestoItemQuantity() {
  //   List<ItemQuantity> tempItemQuantityList = [];
  //   for (int i = 0; i < widget.listItems.length; i++) {
  //     tempItemQuantityList.add(ItemQuantity(id: widget.listItems[i].dishid!));
  //     // final item = ref.read(quantityProvider);
  //     print('${ref.read(quantityProvider.notifier).state}');
  //   }

  //   ref.read(quantityProvider.notifier).update((state) => tempItemQuantityList);
  // }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.listItems.length,
        (context, index) {
          final product = widget.listItems[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Divider(
                  color: Colors.black38,
                  thickness: 2,
                ),
                Consumer(builder: (context, ref, child) {
                  final itemQuantity = ref.watch(quantityProvider).firstWhere(
                        (item) => item.id == product.dishid,
                        orElse: () => ItemQuantity(
                          id: widget.listItems[index].dishid!,
                          quantity: 0,
                        ),
                      );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38, // Adjust shadow opacity
                                offset: Offset(1, 1),
                                // spreadRadius: ,
                                blurRadius: 6,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.listItems[index].dish_imageurl!,
                              fit: BoxFit.contain,
                              width: size.width * 0.20,
                              height: size.width * 0.20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.dish_name!,
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.dish_description!,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: size.width * 0.04,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$ ${product.dish_price}",
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceInOut,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity:
                                        itemQuantity.quantity > 0 ? 1.0 : 1.0,
                                    child: itemQuantity.quantity > 0
                                        ? Container(
                                            // width:
                                            //     size.width *
                                            //         0.09,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey[200]),
                                            child: Column(
                                              children: [
                                                QuantityButton(
                                                  radiustopleft: 10,
                                                  radiustopright: 10,
                                                  // buttonradius:
                                                  //     10,
                                                  buttonheight:
                                                      size.width * 0.09,
                                                  buttonwidth:
                                                      size.width * 0.09,
                                                  icon: Icons.remove,
                                                  iconColor: Colors.white,
                                                  iconSize: size.width * 0.055,
                                                  bgcolor: Colors.black,
                                                  onpress: () {
                                                    int dishindex = ref
                                                        .read(quantityProvider
                                                            .notifier)
                                                        .state
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            product.dishid);

                                                    if (dishindex != -1) {
                                                      ref
                                                          .read(quantityProvider
                                                              .notifier)
                                                          .update((state) {
                                                        if (state[dishindex]
                                                                .quantity >
                                                            0) {
                                                          state[dishindex]
                                                              .quantity--;
                                                        }
                                                        return [...state];
                                                      });
                                                    }
                                                  },
                                                ),
                                                Center(
                                                  child: Text(
                                                    " ${itemQuantity.quantity}",
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.05,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                QuantityButton(
                                                  radiusbottomleft: 10,
                                                  radiusbottomright: 10,
                                                  // radiustopleft:
                                                  //     10,
                                                  // radiustopright:
                                                  //     10,
                                                  // buttonradius:
                                                  //     10,
                                                  icon: Icons.add,
                                                  iconColor: Colors.white,
                                                  iconSize: size.width * 0.055,
                                                  bgcolor: Colors.black,
                                                  buttonheight:
                                                      size.width * 0.08,
                                                  buttonwidth:
                                                      size.width * 0.09,
                                                  onpress: () {
                                                    final dishIndex = ref
                                                        .read(quantityProvider
                                                            .notifier)
                                                        .state
                                                        .indexWhere((item) =>
                                                            item.id ==
                                                            product.dishid);
                                                    if (dishIndex != -1) {
                                                      ref
                                                          .read(quantityProvider
                                                              .notifier)
                                                          .update((state) {
                                                        state[dishIndex]
                                                            .quantity++;

                                                        if (ref
                                                                .read(quantityProvider
                                                                    .notifier)
                                                                .state[
                                                                    dishIndex]
                                                                .quantity >
                                                            0) {
                                                          ref
                                                              .read(
                                                                  showAddProvider
                                                                      .notifier)
                                                              .state = true;
                                                        }

                                                        return [
                                                          ...state
                                                        ]; // return a new state
                                                      });
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        : QuantityButton(
                                            bgcolor: Colors.black,
                                            buttonheight: size.width * 0.08,
                                            buttonwidth: size.width * 0.09,
                                            // buttonradius:
                                            //     10,
                                            radiustopleft: 10,
                                            radiustopright: 10,
                                            radiusbottomleft: 10,
                                            radiusbottomright: 10,
                                            icon: Icons.add,
                                            iconColor: Colors.white,
                                            iconSize: size.width * 0.055,
                                            onpress: () {
                                              var dish = ref
                                                  .read(
                                                      quantityProvider.notifier)
                                                  .state
                                                  .indexWhere((item) =>
                                                      item.id ==
                                                      product.dishid);
                                              if (dish != -1) {
                                                ref
                                                    .read(quantityProvider
                                                        .notifier)
                                                    .update((state) {
                                                  state[dish].quantity++;

                                                  return [...state];
                                                });
                                              }
                                            },
                                          )),
                              ]),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ListItemHeaderSliver extends StatelessWidget {
  const ListItemHeaderSliver(
      {super.key, required this.listCategory, required this.HeaderNotifier});

  final List<Categories> listCategory;
  final HeaderNotifier;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder<MyHeader?>(
            valueListenable: HeaderNotifier,
            builder: (_, snapshot, __) {
              return Row(
                children: List.generate(
                  listCategory.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == snapshot?.index
                            ? Colors.white
                            : Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        listCategory[index].category_name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: index == snapshot?.index
                                ? Colors.black
                                : Colors.white),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}

class MySizedBox extends StatelessWidget {
  const MySizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
    );
  }
}
