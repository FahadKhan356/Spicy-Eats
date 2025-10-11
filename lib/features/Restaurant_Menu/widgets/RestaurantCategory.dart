import 'package:flutter/material.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
import 'package:spicy_eats/commons/bloc.dart';

class RestaurantCategory extends StatelessWidget {
  const RestaurantCategory({super.key, required this.category});
  final Categories? category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // color: Colors.red,
        height: categoryHeight,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              elevation: 0,
              color: Colors.white,
              child: Text(
                category!.category_name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
        ));
  }
}
