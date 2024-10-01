import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RestaurantContainer extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final double ratings;
  final int mindeliverytime;
  final int maxdeliverytime;

  const RestaurantContainer({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.ratings,
    required this.mindeliverytime,
    required this.maxdeliverytime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: AspectRatio(
            aspectRatio: 16 / 8,
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width - 70,
                  top: 20,
                  child: Container(
                    //color: Colors.white,
                    child: const Icon(
                      Icons.favorite_outline_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                name,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFD1C4E9)),
              child: Center(
                child: Text(
                  ratings.toString(),
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        Row(children: [
          Text(
            "\$$price",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "$mindeliverytime-$maxdeliverytime",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ]),
      ],
    );
  }
}
