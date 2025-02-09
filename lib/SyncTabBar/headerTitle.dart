//MyHeaderTitle
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';

const headertitle = 100.0;
typedef OnHeaderChange = void Function(bool visible);

class MyHeaderTitle extends SliverPersistentHeaderDelegate {
  final OnHeaderChange onHeaderChange;
  List<Categories> titles;
  final int index;

  MyHeaderTitle({
    required this.onHeaderChange,
    required this.titles,
    required this.index,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    if (shrinkOffset > 0) {
      onHeaderChange(true);

      print('$shrinkOffset yaha par header true horha hai');
    } else {
      onHeaderChange(false);
      print('$shrinkOffset yaha par header false horha hai');
    }
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        //  color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            index != 0
                ? Divider(
                    thickness: 5,
                    color: Colors.blueGrey,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 5,
                        width: size.width / 3,
                        color: Colors.black12,
                      ),
                      const Text(
                        "Menu",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 5,
                        width: size.width / 3,
                        color: Colors.black12,
                      ),
                    ],
                  ),
          ],
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
