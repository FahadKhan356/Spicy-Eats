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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
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
                    right: size.width * 0.03,
                    top: 20,
                    child: Container(
                      //color: Colors.white,
                      child: Icon(
                        Icons.favorite_outline_rounded,
                        size: size.width * 0.09,
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
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: size.width * 0.045,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                      ),

                      Row(children: [
                        Text(
                          "\$$price",
                          style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$mindeliverytime-$maxdeliverytime",
                          style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [

                      //       Container(
                      //         height: size.width * 0.1,
                      //         width: size.width * 0.1,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: const Color(0xFFD1C4E9)),
                      //         child: Center(
                      //           child: Text(
                      //             ratings.toString(),
                      //             style: TextStyle(
                      //                 fontSize: size.width * 0.04,
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ],
                    ]),
              ),
              Container(
                height: size.width * 0.1,
                width: size.width * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFD1C4E9)),
                child: Center(
                  child: Text(
                    ratings.toString(),
                    style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
