import 'package:flutter/material.dart';

void mysnackbar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void floatingsnackBar({required BuildContext context, required String text}) {
  SnackBar snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: Colors.black),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.indigo[100],
    clipBehavior: Clip.antiAlias,
    duration: const Duration(milliseconds: 200),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
