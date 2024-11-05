import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuantityButton extends StatelessWidget {
  double? radiustopleft;
  double? radiusbottomleft;
  double? radiustopright;
  double? radiusbottomright;
  double? buttonheight;
  double? buttonwidth;
  IconData icon;
  Color iconColor;
  double iconSize;
  Color? bgcolor;
  double? buttonradius;
  VoidCallback onpress;
  QuantityButton({
    this.radiusbottomleft,
    this.radiustopleft,
    this.radiusbottomright,
    this.radiustopright,
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
          border: Border.all(width: 5, color: Colors.black),
          borderRadius: BorderRadius.only(
            topLeft: radiustopleft == 0
                ? const Radius.circular(0)
                : Radius.circular(radiustopleft ?? 0),
            bottomLeft: radiusbottomleft == 0
                ? const Radius.circular(0)
                : Radius.circular(radiusbottomleft ?? 0),
            topRight: radiustopright == 0
                ? const Radius.circular(0)
                : Radius.circular(radiustopright ?? 0),
            bottomRight: radiusbottomright == 0
                ? const Radius.circular(0)
                : Radius.circular(radiusbottomright ?? 0),
          ),
          // buttonradius == 0
          // ? BorderRadius.circular(35)
          // : BorderRadius.circular(buttonradius ?? 35),
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
