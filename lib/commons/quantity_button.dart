import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuantityButton extends StatelessWidget {
  double? buttonheight;
  double? buttonwidth;
  IconData icon;
  Color iconColor;
  double iconSize;
  Color? bgcolor;
  double? buttonradius;
  VoidCallback onpress;
  QuantityButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    this.bgcolor,
    required this.onpress,
    this.buttonheight,
    this.buttonwidth,
    this.buttonradius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonheight == 0 ? 70 : buttonheight,
      width: buttonwidth == 0 ? 70 : buttonwidth,
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.black),
          borderRadius: buttonradius == 0
              ? BorderRadius.circular(35)
              : BorderRadius.circular(buttonradius ?? 35),
          color: bgcolor ?? Colors.black),
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
