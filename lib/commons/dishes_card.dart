import 'package:flutter/material.dart';
import 'package:spicy_eats/commons/ItemQuantity.dart';
import 'package:spicy_eats/commons/quantity_button.dart';

class DishesCard extends StatefulWidget {
  final String dishname;
  final String dishdescription;
  final String dishprice;
  final int index;
  final String? image;
  final int? quantity;
  final int? id;
  final List<ItemQuantity>? dishitems;

  DishesCard({
    super.key,
    required this.dishname,
    required this.dishdescription,
    required this.dishprice,
    required this.index,
    required this.image,
    this.quantity,
    this.id,
    this.dishitems,
  });

  @override
  State<DishesCard> createState() => _DishesCardState();
}

class _DishesCardState extends State<DishesCard> {
  List<ItemQuantity>? dishes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.index == 0
              ? const Text(
                  "Menu",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )
              : const SizedBox(),
          widget.index != 0
              ? const Divider(
                  height: 4,
                  thickness: 4,
                  color: Colors.black26,
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              widget.image != null && widget.image!.isNotEmpty
                  ? Image.network(
                      widget.image!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dishname,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.dishdescription,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "\$ ${widget.dishprice}",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuantityButton(
                      buttonheight: 40,
                      icon: Icons.remove,
                      iconColor: Colors.black,
                      iconSize: 30,
                      bgcolor: Colors.white,
                      onpress: () {}),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  QuantityButton(
                    icon: Icons.add,
                    iconColor: Colors.black,
                    iconSize: 30,
                    bgcolor: Colors.white,
                    buttonheight: 40,
                    onpress: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
