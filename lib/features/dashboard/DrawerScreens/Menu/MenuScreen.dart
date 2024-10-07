import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/dashboard/DrawerScreens/Menu/SubScreens/AddItemScreen.dart';
import 'package:spicy_eats/features/dashboard/DrawerScreens/Menu/overview.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

late TabController tabBarController;

class _MenuScreenState extends ConsumerState<MenuScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    tabBarController = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              controller: tabBarController,
              // dividerColor: const Color.fromRGBO(33, 33, 33, 1),
              padding: const EdgeInsets.only(bottom: 10),
              indicatorColor: Colors.white,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'ADD DISH',
                    style: TextStyle(
                        fontSize: size.width * 0.035, color: Colors.white),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'OVERVIEW',
                    style: TextStyle(
                        fontSize: size.width * 0.03, color: Colors.white),
                  ),
                )),
              ]),
        ),
        body: TabBarView(controller: tabBarController, children: [
          AddItemScreen(),
          const OverviewScreen(),
          // const Center(
          //   child: Text('overview'),
          //)
        ]),
      ),
    );
  }
}
