//HeaderSliver
import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';
import 'package:spicy_eats/SyncTabBar/ListItemHeaderSliver.dart';
import 'package:spicy_eats/SyncTabBar/SliverHeaderData.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';

const _maxHeaderExtent = 100.0;

class HeaderSliver extends SliverPersistentHeaderDelegate {
  HeaderSliver(
      {required this.listCategory,
      required this.headernotifier,
      required this.restauarantdata});

  List<Categories> listCategory;
  final RestaurantModel restauarantdata;
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                          opacity: percent > 0.1 ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      AnimatedSlide(
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 300),
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
                                  percent > 0.1 ? Colors.white : Colors.white,
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
                duration: const Duration(milliseconds: 600),
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
