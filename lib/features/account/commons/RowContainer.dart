import 'package:flutter/material.dart';

Widget rowContainer({
  required IconData icon,
  required VoidCallback onpressed,
  required String title,
}) {
  return InkWell(
    onTap: onpressed,
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.black12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          )
        ],
      ),
    ),
  );
}
