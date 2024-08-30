import 'package:flutter/material.dart';
import 'package:spicy_eats/commons/quantity_button.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Basket/screens/basket.dart';

class MenuItemDetailScreen extends StatefulWidget {
  static const String routename = "/Menu-item-detail";
  final Dish dish;

  const MenuItemDetailScreen({
    super.key,
    required this.dish,
  });

  @override
  State<MenuItemDetailScreen> createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  int quantity = 1;
  late double totalprice;

  @override
  void initState() {
    super.initState();
    totalprice = widget.dish.price;
  }

  void increment() {
    setState(() {
      if (quantity < 10) {
        quantity++;
        totalprice = widget.dish.price * quantity;
      }
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        totalprice = widget.dish.price * quantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dish.name,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.dish.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(
              height: 4,
              thickness: 4,
              color: Color.fromARGB(87, 226, 211, 211),
            ),
            const SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuantityButton(
                    icon: Icons.remove,
                    iconColor: Colors.black,
                    iconSize: 50,
                    bgcolor: Colors.white,
                    onpress: decrement,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      quantity.toString(),
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
                    iconSize: 50,
                    bgcolor: Colors.white,
                    onpress: increment,
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(
                    context, BasketScreen.routename,
                    arguments: {
                      'dish': widget.dish,
                      'totalprice': totalprice,
                      'quantity': quantity,
                    }),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Text(
                      'Add $quantity to basket',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${totalprice.toStringAsFixed(2)} \$",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
