import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Practice%20for%20cart/logic/Dummylogics.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

class DummyBasket extends ConsumerStatefulWidget {
  List<DishData> dishes = [];
  static const String routename = "/Dummy_basket";
  DummyBasket({
    super.key,
    required this.cart,
    required this.dishes,
  });
  List<CartModelNew> cart = [];

  @override
  ConsumerState<DummyBasket> createState() => _DummyBasketState();
}

class _DummyBasketState extends ConsumerState<DummyBasket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Your Basket ${widget.cart.length}'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final cartitem = widget.cart[index];
                  final dishindex = widget.dishes.firstWhere(
                      (dish) => dish.dishid == widget.cart[index].dish_id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                      cartitem.image.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("x ${cartitem.quantity}"),
                                      Text("\$${cartitem.tprice!}"),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(DummyLogicProvider)
                                          .increaseQuantity(
                                            ref,
                                            cartitem.dish_id!,
                                            // cartitem.tprice!.toInt(),
                                            dishindex.dish_price!,
                                          );
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      child: const Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    cartitem.quantity.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(DummyLogicProvider)
                                          .decreaseQuantity(
                                            ref,
                                            cartitem.dish_id,
                                            cartitem.tprice!.toInt(),
                                          );
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.minimize_outlined,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Total',
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Spacer(),
          Container(
            height: 200,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Products'),
                      Text('\$12.33'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text('\$52.33'),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("PROCEED TO CHECKOUT"),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
          ),
        ],
      ),
    );
  }
}
