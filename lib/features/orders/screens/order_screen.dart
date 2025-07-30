import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spicy_eats/commons/dishes_card.dart';
import 'package:spicy_eats/commons/orderModel.dart';

class OrdersScreen extends StatelessWidget {
  static const String routename = '/orders';

  Future<List<Orders>> readjsonOrders() async {
    var data = await rootBundle.loadString('lib/assets/data/orders.json');
    var decoded = await jsonDecode(data) as List<dynamic>;
    return decoded.map((i) => Orders.fromjson(i)).toList();
  }

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_outlined)),
        title: const Text(
          'Your orders',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: readjsonOrders(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  var data = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.black38, width: 1)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                        errorBuilder:
                                            (context, error, StackTrace) =>
                                                const Icon(Icons.image),
                                        height: 80,
                                        width: 80,
                                        'https://assets.epicurious.com/photos/60d1e9fbd62cfdf9e277542e/1:1/pass/ChickenMushroomBurger_RECIPE_061721_18256.jpg'),
                                  ),
                                ),
                                const Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pehalwan Beef',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'Nali Biryani',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Delivered on  05 Jan, 02:43',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      Text(
                                        'Beef Biryani',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Rs. 206.66',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: Colors.black),
                                onPressed: () {},
                                child: const Text(
                                  'Select items to reorder',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            }
          }),
        ),
      ),
    );
  }
}
