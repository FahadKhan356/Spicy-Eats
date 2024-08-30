import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String hintext;
  final void Function(String) onchanged;
  final String? Function(String?) onvalidator;

  const CustomTextfield({
    super.key,
    this.controller,
    required this.hintext,
    required this.title,
    required this.onchanged,
    required this.onvalidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        TextFormField(
          validator: onvalidator,
          onChanged: onchanged,
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black)),
              // hintText: '\$20.0',
              hintText: hintext,
              hintStyle: const TextStyle(color: Colors.black54),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black))),
        ),
      ],
    );
  }
}
