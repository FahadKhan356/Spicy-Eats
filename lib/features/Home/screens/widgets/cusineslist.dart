import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:spicy_eats/commons/consts.dart';

class CusinesList extends StatelessWidget {
  const CusinesList({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width * 0.3,
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cusines.length,
              itemBuilder: ((context, index) => Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: size.width * 0.10,
                          width: size.width * 0.10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.red,
                            // boxShadow: const [
                            //   BoxShadow(
                            //     color: Colors.black54,
                            //     spreadRadius: 2,
                            //     blurRadius: 2,
                            //     offset: Offset(1, 1),
                            //   )
                            // ]
                          ),
                          child: Image.asset(
                            cusineImages[index],
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        cusines[index],
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
