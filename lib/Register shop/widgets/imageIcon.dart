import 'package:flutter/material.dart';

class ImageIconWidget extends StatelessWidget {
  const ImageIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.width * 0.23,
        width: size.width * 0.23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(width: 3, color: Colors.black),
          color: Colors.amber,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.network(
            'https://plus.unsplash.com/premium_photo-1664536392896-cd1743f9c02c?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            fit: BoxFit.cover,
          ),
        ));
  }
}
