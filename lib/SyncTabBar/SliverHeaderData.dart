import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';

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
                    '${restaurantdata.maxTime} - ${restaurantdata.minTime} Min | ${restaurantdata.averageRatings}',
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
