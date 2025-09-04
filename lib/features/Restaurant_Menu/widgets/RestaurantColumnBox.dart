import 'dart:ui';

import 'package:flutter/material.dart';

class RestaurantColumnBox extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Widget? widgetOne;
  final Widget? widgetSecond;
  final double? boxHeight;
  final double? boxWidth;

  const RestaurantColumnBox(
      {super.key,
      this.top,
      this.bottom,
      this.left,
      this.right,
      this.widgetOne,
      this.widgetSecond,
      this.boxHeight,
      this.boxWidth});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: boxHeight,
            width: boxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetOne ?? const SizedBox(),
                const SizedBox(height: 2),
                widgetSecond ?? const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
