import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/imageIcon.dart';

var indexDrawerProvider = StateProvider((ref) => 0);

class DrawerRow extends StatelessWidget {
  final IconData icon;
  final String text;
  DrawerRow({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.all(5),
        // color: Colors.red,
        child: Column(
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFD1C4E9)),
              child: Icon(
                icon,
                size: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  overflow: TextOverflow.visible),
            ),
          ],
        ),
      ],
    ));
  }
}

class MyDrawer extends ConsumerWidget {
  MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: 300,
          width: double.infinity,
          child: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Column(
                children: [
                  Center(child: ImageIconWidget()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ElCaboCoffe@gmail.com',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        overflow: TextOverflow.visible),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: drawerList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ShopHome.routename,
                  );
                  ref.read(indexDrawerProvider.notifier).state = index;
                },
                child: Column(
                  children: [
                    //index != 0 ? const Divider() : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index ==
                                    ref.read(indexDrawerProvider.notifier).state
                                ? const Color(0xFFD1C4E9)
                                : Colors.transparent,
                          ),
                          child: drawerList[index]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
