import 'package:flutter/material.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';

const double headertitle = 100;

class SecondHeaderTitle extends SliverPersistentHeaderDelegate {
  List<Categories> titles;
  int index;
  SecondHeaderTitle({required this.titles, required this.index});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: headertitle,
      // color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              color: Colors.red,
              child: Text(
                titles[index].category_name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
