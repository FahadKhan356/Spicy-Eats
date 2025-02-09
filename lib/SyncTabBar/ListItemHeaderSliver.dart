import 'package:flutter/material.dart';
import 'package:spicy_eats/SyncTabBar/MyHeader.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';

class ListItemHeaderSliver extends StatelessWidget {
  const ListItemHeaderSliver(
      {super.key, required this.listCategory, required this.HeaderNotifier});

  final List<Categories> listCategory;
  final HeaderNotifier;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder<MyHeader?>(
            valueListenable: HeaderNotifier,
            builder: (_, snapshot, __) {
              return Row(
                children: List.generate(
                  listCategory.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == snapshot?.index ? Colors.white : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        listCategory[index].category_name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: index == snapshot?.index
                                ? Colors.black
                                : Colors.white),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
