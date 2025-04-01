import 'package:flutter/material.dart';

Widget commonContainer(
    {required String title,
    required String titlename,
    required VoidCallback onpressed}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: double.maxFinite,
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(blurRadius: 5, spreadRadius: 1, color: Colors.black12)
    ], borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(
                  height: 10,
                ),
                Text(titlename),
              ],
            ),
            IconButton(
                onPressed: onpressed, icon: const Icon(Icons.edit_outlined)),
          ],
        )
      ],
    ),
  );
}
