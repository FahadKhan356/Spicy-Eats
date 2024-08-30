import 'package:flutter/material.dart';

Widget paymentTextfields({
  String? label,
  final String? Function(String?)? onvalidator,
}) {
  return TextFormField(
    decoration: InputDecoration(labelText: label),
    validator: onvalidator,
  );
}
