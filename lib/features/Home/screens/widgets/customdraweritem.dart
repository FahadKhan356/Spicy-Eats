import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawerItem extends StatefulWidget {
  final String leadingname;
  final IconData icon;
  const CustomDrawerItem(
      {super.key, required this.leadingname, required this.icon});

  @override
  State<CustomDrawerItem> createState() => _CustomDrawerItemState();
}

class _CustomDrawerItemState extends State<CustomDrawerItem> {
  var colorchange = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: MediaQuery.of(context).size.width * 0.0522,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.leadingname,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.0379),
          ),
        ],
      ),
    );
  }
}
