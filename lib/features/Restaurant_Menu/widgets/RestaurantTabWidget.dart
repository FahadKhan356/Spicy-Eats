import 'package:flutter/material.dart';
import 'package:spicy_eats/diegoveloper%20example/bloc.dart';

class RestaurantTabWidget extends StatefulWidget {
  final RapitabCategory? category;
  const RestaurantTabWidget({super.key, required this.category});

  @override
  State<RestaurantTabWidget> createState() => _RestaurantTabWidgetState();
}

class _RestaurantTabWidgetState extends State<RestaurantTabWidget> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.category!.selected ?? false;
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      borderOnForeground: false,
      color: isSelected ? Colors.black : Colors.white,
      elevation: isSelected ? 6 : 0,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.category!.category.category_name.toString(),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
