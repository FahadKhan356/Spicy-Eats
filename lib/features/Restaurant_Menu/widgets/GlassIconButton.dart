import 'dart:ui';

import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final double? width;
  final double? height;

  const GlassIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            height:
                height ?? size.width / 0.034, // slightly smaller for balance
            width: width ?? size.width / 0.34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22,
                color: iconColor ?? Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
