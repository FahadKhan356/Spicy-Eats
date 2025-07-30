import 'package:flutter/cupertino.dart';
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
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: size.width * 0.045, color: Colors.black),
          ),
        ),
        TextFormField(
          validator: onvalidator,
          onChanged: onchanged,
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
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
