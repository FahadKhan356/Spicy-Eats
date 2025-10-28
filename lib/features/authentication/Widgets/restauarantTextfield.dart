import 'package:flutter/material.dart';

class RestaurantTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String hintext;
  final double? size;

  final String? Function(String?) onvalidator;

  const RestaurantTextfield({
    super.key,
    this.controller,
    required this.hintext,
    required this.title,
    required this.onvalidator,
    this.size = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: size, color: Colors.black),
        ),
        TextFormField(
          validator: onvalidator,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
              //const BorderSide(width: 2, color: Colors.black)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              //const BorderSide(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: hintext,
            hintStyle: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
