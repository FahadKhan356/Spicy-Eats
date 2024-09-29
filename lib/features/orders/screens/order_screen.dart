import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spicy_eats/commons/dishes_card.dart';
import 'package:spicy_eats/commons/orderModel.dart';

class OrdersScreen extends StatelessWidget {
  Future<List<Orders>> readjsonOrders() async {
    var data = await rootBundle.loadString('lib/assets/data/orders.json');
    var decoded = await jsonDecode(data) as List<dynamic>;
    return decoded.map((i) => Orders.fromjson(i)).toList();
  }

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    'Your orders',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: readjsonOrders(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        height: 599,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) {
                              var data = snapshot.data![index];
                              return DishesCard(
                                dishname: data.restaurant.name,
                                dishdescription:
                                    data.restaurant.deliveryfee.toString(),
                                dishprice: data.restaurant.createdAt.toString(),
                                index: index,
                                image: data.restaurant.image,
                              );
                            })),
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
