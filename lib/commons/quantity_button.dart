import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuantityButton extends StatelessWidget {
  IconData icon;
  Color iconColor;
  double iconSize;
  Color bgcolor;
  VoidCallback onpress;
  QuantityButton(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.iconSize,
      required this.bgcolor,
      required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.black),
        borderRadius: BorderRadius.circular(35),
        //color: Colors.amber),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onpress,
        icon: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
