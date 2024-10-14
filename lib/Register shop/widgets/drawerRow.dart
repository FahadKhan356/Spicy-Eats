import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/drawerrow.dart';
import 'package:spicy_eats/Register%20shop/widgets/imageIcon.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';

var indexDrawerProvider = StateProvider((ref) => 0);
var pagetitle = StateProvider<String?>((ref) => 'menu');

class DrawerRow extends StatelessWidget {
  final IconData icon;
  final String text;
  DrawerRow({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        // margin: EdgeInsets.all(5),
        // color: Colors.red,
        child: Column(
      children: [
        Row(
          children: [
            Container(
              height: size.width * 0.1,
              width: size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFD1C4E9)),
              child: Icon(
                icon,
                size: size.width * 0.05,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: size.width * 0.04,
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
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        DrawerButton(
          style:
              ButtonStyle(iconColor: MaterialStateProperty.all(Colors.white)),
        ),
        Container(
          color: Colors.white10,
          height: size.width * 0.5,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Column(
                children: [
                  const Center(child: ImageIconWidget()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ElCaboCoffe@gmail.com',
                    style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.black,
                        overflow: TextOverflow.visible),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: drawerList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ShopHome.routename,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index ==
                                ref.read(indexDrawerProvider.notifier).state
                            ? Colors.white //const Color(0xFFD1C4E9)
                            : Colors.transparent,
                      ),
                      child: drawerList[index]),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 5,
          color: Colors.black,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: Text(
              'Main Screen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    //  var rest_uid = ref.watch(rest_ui_Provider);
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.521),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              DrawerButton(
                style: ButtonStyle(
                    iconColor: MaterialStateProperty.all(Colors.white)),
              ),
              Container(
                color: Colors.white10,
                height: size.width * 0.5,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Column(
                      children: [
                        const Center(child: ImageIconWidget()),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'ElCaboCoffe@gmail.com',
                          style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: Colors.black,
                              overflow: TextOverflow.visible),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index ==
                                      ref
                                          .read(indexDrawerProvider.notifier)
                                          .state
                                  ? Colors.white //const Color(0xFFD1C4E9)
                                  : Colors.transparent,
                            ),
                            child: drawerList[index]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: Text(
                    'Main Screen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
