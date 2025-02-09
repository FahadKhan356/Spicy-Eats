import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';

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
            const Positioned(
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
