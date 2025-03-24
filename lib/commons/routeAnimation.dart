import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route customRouteAnimation(Widget child) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, animation, secondaryanimation) =>
          child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder:
          (BuildContext context, animation, secondaryanimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.elasticOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        // .chain(CurveTween(curve:curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
