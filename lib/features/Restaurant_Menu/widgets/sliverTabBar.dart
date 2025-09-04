import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';
import 'package:spicy_eats/diegoveloper%20example/main_rappi_concept_app.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/RestaurantColumnBox.dart';
import 'package:spicy_eats/features/Restaurant_Menu/widgets/RestaurantTabWidget.dart';

const double headertitle = 60;

class SliverTabBar extends SliverPersistentHeaderDelegate {
  final RappiBloc bloc;
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
          // border: Border.symmetric(
          //     horizontal: BorderSide(width: 5, color: Colors.black87)),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            // bottomLeft: Radius.circular(10),
            // bottomRight: Radius.circular(10)
          )),
      child: AnimatedBuilder(
          animation: bloc,
          builder: (_, __) {
            return TabBar(
              tabs: bloc.tabs
                  .map((e) => RestaurantTabWidget(category: e))
                  .toList(),
              padding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              onTap: (index) => bloc.onCategoryTab(index),
              isScrollable: true,
              controller: bloc.tabController,
            );
          }),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}

const double size = 200;

class SliverWidgets extends SliverPersistentHeaderDelegate {
  SliverWidgets();

  @override
  // TODO: implement maxExtent
  double get maxExtent => size;

  @override
  // TODO: implement minExtent
  double get minExtent => size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const RestaurantColumnBox(
      boxHeight: 80,
      boxWidth: 150,
      top: 300,
      left: 20,
      widgetOne: Text(
        'Smash Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      widgetSecond: Text(
        'Fast Food, Burgers',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
