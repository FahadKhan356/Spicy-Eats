import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';

const double headertitle = 60;

class SliverTabBar extends SliverPersistentHeaderDelegate {
  final RestaurantScrollNotifier bloc;
  bool isshowtabbar;
  bool isTabControllerReady;

  SliverTabBar(
      {required this.bloc,
      required this.isTabControllerReady,
      required this.isshowtabbar});

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
            isshowtabbar
                ? BoxShadow(
                    offset: const Offset(0.0, 2.0),
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 5)
                : const BoxShadow(color: Colors.transparent)
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Consumer(
        builder: (context, ref, _) {
          debugPrint(
              '${bloc.tabController?.length} : this is tab length after in slivertabbar ');
          // final bloc = ref.watch(restaurantScrollProvider);
          return TabBar(
            tabs: bloc.tabs.map((e) => Rappi_tab_widget(category: e)).toList(),
            padding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            onTap: (index) => bloc.onCategoryTab(index),
            isScrollable: true,
            controller: bloc.tabController,
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
