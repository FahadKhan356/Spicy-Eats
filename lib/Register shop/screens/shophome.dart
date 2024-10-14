import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/drawerRow.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';

class ShopHome extends ConsumerWidget {
  static const String routename = 'shop-home';

  ShopHome({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.read(indexDrawerProvider);
    void gotoHome() {
      Navigator.popAndPushNamed(context, HomeScreen.routename);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to the desired color
          ),
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0
                    ? 'Menu'
                    : index == 1
                        ? 'Feedback'
                        : index == 2
                            ? 'Payment'
                            : index == 3
                                ? 'Document'
                                : index == 4
                                    ? 'Settings'
                                    : 'Menu',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        ),
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(80),
        //   child: AppBar(
        //     flexibleSpace: Container(
        //       padding: const EdgeInsets.only(top: 10, left: 50, right: 10),
        //       decoration: const BoxDecoration(
        //         color: Colors.white,
        //         // boxShadow: [
        //         //   BoxShadow(
        //         //     color: Colors.black26,
        //         //     spreadRadius: 1,
        //         //     offset: Offset(0, 1),
        //         //     blurRadius: 10,
        //         //   )
        //         // ],
        //       ),
        //       child: Row(
        //         children: [
        //           // ClipRRect(
        //           //   borderRadius: BorderRadius.circular(10),
        //           //   child: Image.network(
        //           //     "https://notjustdev-dummy.s3.us-east-2.amazonaws.com/uber-eats/restaurant1.jpeg",
        //           //     fit: BoxFit.cover,
        //           //     width: 100,
        //           //     height: 100,
        //           //   ),
        //           // ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Flexible(
        //             child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   SizedBox(
        //                     height: 5,
        //                   ),
        //                   Text(
        //                     'El Cabo Coffe Bar Tres De Mayo',
        //                     style: TextStyle(
        //                         fontSize: 18,
        //                         color: Colors.black,
        //                         overflow: TextOverflow.visible),
        //                   ),
        //                   Row(
        //                     children: [
        //                       Icon(
        //                         Icons.location_on,
        //                         size: 20,
        //                         color: Colors.black,
        //                       ),
        //                       Flexible(
        //                         child: Text(
        //                           'MarketSt, San francissco,ca,Usa',
        //                           style: TextStyle(
        //                               fontSize: 15,
        //                               color: Colors.black,
        //                               overflow: TextOverflow.ellipsis),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ]),
        //           ),
        //         ],
        //       ),
        //     ),

        //     // titleTextStyle: const TextStyle(fontSize: 30,overflow: TextOverflow.visible,s),
        //   ),
        // ),

        body: screens[ref.read(indexDrawerProvider.notifier).state],
        drawer: const Padding(
          padding: EdgeInsets.only(top: 50),
          child: DashboardDrawer(),
        ),
        //MyDrawer(),
      ),
    );
  }
}
