import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DishesCard extends StatelessWidget {
  final String dishname;
  final String dishdescription;
  final String dishprice;
  final int index;
  final String? image;

  DishesCard(
      {super.key,
      required this.dishname,
      required this.dishdescription,
      required this.dishprice,
      required this.index,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 0
                        ? const Text(
                            "Menu",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      dishname,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      dishdescription,
                      style: const TextStyle(
                          overflow: TextOverflow.visible,
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "\$ $dishprice",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              image != null && image!.isNotEmpty
                  ? Image.network(
                      image!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
