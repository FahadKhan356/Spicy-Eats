import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/dashboard/DrawerScreens/Menu/SubScreens/AddItemScreen.dart';
import 'package:spicy_eats/Register%20shop/dashboard/DrawerScreens/Menu/overview.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
              isScrollable: true,
              controller: tabBarController,
              // dividerColor: const Color.fromRGBO(33, 33, 33, 1),
              padding: const EdgeInsets.only(bottom: 5),
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 7,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Text('Add Item'),
                Text('Overview'),
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
