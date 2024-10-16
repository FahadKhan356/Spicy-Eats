import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spicy_eats/SyncTabBar/CategoryModel.dart';
import 'package:spicy_eats/SyncTabBar/MyHeader.dart';
import 'package:spicy_eats/SyncTabBar/Sliver_Scroll_controller.dart';

final globalOffsetValues = ValueNotifier<double>(0);
//value to do the validations of the top icons
final valueScroll2 = ValueNotifier<double>(0);

class HomeSliverWithScrollableTabs extends StatefulWidget {
  const HomeSliverWithScrollableTabs({super.key});

  @override
  State<HomeSliverWithScrollableTabs> createState() =>
      _HomeSliverWithScrollableTabsState();
}

class _HomeSliverWithScrollableTabsState
    extends State<HomeSliverWithScrollableTabs> {
  Future<List<Category>?> readjsoncategory() async {
    final response =
        await rootBundle.loadString('lib/assets/data/category.json');
    final List<dynamic> list = jsonDecode(response);
    return list.map((e) => Category.fromjson(e)).toList();
  }

  SliverScrollController? sliverScrollController;
  late ScrollController scrollControllerItemHeader;

  //to have overall controll of scrolling
  late ScrollController scrollControllerGlobally;

  List<Category> category = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollControllerItemHeader = ScrollController();
    scrollControllerGlobally = ScrollController();
    readjsoncategory().then((value) {
      if (value != null) {
        setState(() {
          category = value;
        });
      }
      scrollControllerGlobally.addListener(() {
        globalOffsetValues.value = scrollControllerGlobally.offset;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollControllerItemHeader.dispose();
    scrollControllerGlobally.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerNotifier = ValueNotifier<MyHeader?>(null);

    void refreshHeader({
      required int index,
      required bool visible,
      required int? lastIndex,
    }) {
      final headerValue = headerNotifier.value;
      final headerTitle = headerValue?.index ?? index;
      final headerVisible = headerValue?.visible ?? false;

      if (headerTitle != index ||
          lastIndex == null ||
          headerVisible != visible) {
        Future.microtask(() {
          if (!visible && lastIndex != null) {
            headerNotifier.value = MyHeader(visible: true, index: lastIndex);
          } else {
            headerNotifier.value = MyHeader(visible: visible, index: index);
          }
        });
      }
    }

    return Scaffold(
      body: Scrollbar(
        notificationPredicate: (scroll) {
          valueScroll2.value = scroll.metrics.extentInside;
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
                    valueScroll: valueCurrentScroll,
                  ),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: HeaderSliver(
                          listCategory: category,
                          headernotifier: headerNotifier)),
                  for (int i = 0; i < category.length; i++) ...[
                    SliverPersistentHeader(
                      delegate: MyHeaderTitle(
                          title: category[i].name,
                          onHeaderChange: (visible) => refreshHeader(
                              index: i,
                              visible: visible,
                              lastIndex: i > 0 ? i - 1 : null)),
                    ),
                    SliverBodyItems(listItems: category[i].products)
                  ]
                ],
              );
            }),
      ),
    );
  }
}

class FlexibleSpaceBarHeader extends StatelessWidget {
  const FlexibleSpaceBarHeader({super.key, required this.valueScroll});
  final double valueScroll;
  @override
  Widget build(BuildContext context) {
    final sizeheight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      stretch: true,
      pinned: valueScroll < 90 ? true : false,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundSliver(),
            Positioned(
                top: (sizeheight + 20) - valueScroll2.value,
                right: 10,
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                )),
            Positioned(
                top: (sizeheight + 20) - valueScroll2.value,
                left: 10,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

//BackgroundSliver
class BackgroundSliver extends StatelessWidget {
  const BackgroundSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Image.network(
      "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.darken,
      color: Colors.black.withOpacity(0.2),
    ));
  }
}

//MyHeaderTitle
const headertitle = 80.0;
typedef OnHeaderChange = void Function(bool visible);

class MyHeaderTitle extends SliverPersistentHeaderDelegate {
  final OnHeaderChange onHeaderChange;
  final String title;

  MyHeaderTitle({
    required this.onHeaderChange,
    required this.title,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (shrinkOffset > 0) {
      onHeaderChange(true);
    } else {
      onHeaderChange(false);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => headertitle;

  @override
  // TODO: implement minExtent
  double get minExtent => headertitle;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

//HeaderSliver
const _maxHeaderExtent = 100.0;

class HeaderSliver extends SliverPersistentHeaderDelegate {
  HeaderSliver({required this.listCategory, required this.headernotifier});

  List<Category> listCategory;
  final headernotifier;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Colors.blue,
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
                          child: Icon(Icons.arrow_back)),
                      AnimatedSlide(
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 300),
                          offset: Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                          child: const Text('Kevsoft Bakery ')),
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
                        : SliverHeaderData(),
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
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asiatisch , koreanisch , Japanisch',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(
                width: 4,
              ),
              Text('30-40 Min 4.3', style: TextStyle(fontSize: 12)),
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
          )
        ],
      ),
    );
  }
}

class SliverBodyItems extends StatelessWidget {
  SliverBodyItems({super.key, required this.listItems});

  List<Product> listItems;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        final product = listItems[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 140,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: NetworkImage(product.imageUrl))),
                    ),
                  ],
                ),
              ),
              if (index == listItems.length - 1) ...[
                const SizedBox(
                  height: 500,
                ),
                Container(
                  height: 0.5,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ],
          ),
        );
      },
      childCount: listItems.length,
    ));
  }
}

class ListItemHeaderSliver extends StatelessWidget {
  const ListItemHeaderSliver(
      {super.key, required this.listCategory, required this.HeaderNotifier});

  final List<Category> listCategory;
  final HeaderNotifier;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder(
            valueListenable: HeaderNotifier,
            builder: (_, MyHeader? snapshot, __) {
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
                        color: index == snapshot?.index ? Colors.white : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        listCategory[index].name,
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
