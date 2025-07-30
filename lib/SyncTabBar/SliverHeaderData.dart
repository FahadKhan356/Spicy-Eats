import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';

class SliverHeaderData extends StatelessWidget {
  const SliverHeaderData({
    super.key,
    required this.restaurantdata,
  });

  final RestaurantModel restaurantdata;

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
          const SizedBox(
            height: 6,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time),
                const SizedBox(
                  width: 4,
                ),
                Text(
                    '${restaurantdata.maxTime} - ${restaurantdata.minTime} Min | ${restaurantdata.averageRatings}',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(
                  width: 6,
                ),
                const Icon(
                  Icons.star,
                  size: 14,
                ),
                const SizedBox(
                  width: 6,
                ),
                const Text('\$6.5 fee', style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
