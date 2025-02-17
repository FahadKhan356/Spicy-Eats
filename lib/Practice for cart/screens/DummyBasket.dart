import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/cart_model_new.dart';

class DummyBasket extends StatefulWidget {
  static const String routename = "/Dummy_basket";
  DummyBasket({super.key, required this.cart});
  List<CartModelNew> cart = [];

  @override
  State<DummyBasket> createState() => _DummyBasketState();
}

class _DummyBasketState extends State<DummyBasket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Basket ${widget.cart.length}'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final cartitem = widget.cart[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                                    Text("\$${cartitem.tprice}"),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Center(
                                        child: Icon(
                                      Icons.add,
                                    )),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                              width: 2, color: Colors.black)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "3",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Center(child: Icon(Icons.remove)),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                              width: 2, color: Colors.black)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
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
      ),
    );
  }
}
