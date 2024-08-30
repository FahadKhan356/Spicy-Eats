import 'package:flutter/material.dart';

Widget bgWisget({Widget? child, BuildContext? context}) {
  return Container(
    height: MediaQuery.of(context!).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: Colors.black12,
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.color),
            scale: 100,
            image: const AssetImage(
              'lib/assets/images/bgimage2.jpg',
            ),
            fit: BoxFit.cover)),
    child: child,
  );
}
