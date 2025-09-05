import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/commons/Responsive.dart';
import 'package:spicy_eats/features/Home/screens/customnavbar.dart';
import 'package:spicy_eats/main.dart';

var currentIndexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerStatefulWidget {
  static const String routename = '/Home';
  Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    var currentIndex = ref.watch(currentIndexProvider);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: screen[currentIndex],
        floatingActionButton: supabaseClient.auth.currentSession != null
            ? Padding(
                padding:
                   EdgeInsets.symmetric(horizontal: Responsive.w20px, vertical: Responsive.w10px),
                child: AnimatedNavBar(
                  selectedIndex: currentIndex,
                  onItemTapped: (index) {
                    ref
                        .read(currentIndexProvider.notifier)
                        .update((state) => index);
                  },
                ),
              )
            //  BottomNavigationBar(
            //     items: bitems,
            //     onTap: (index) {
            //       ref
            //           .read(currentIndexProvider.notifier)
            //           .update((state) => index);
            //     },
            //     currentIndex: currentIndex,
            //     selectedItemColor: Colors.black,
            //     unselectedItemColor: Colors.black38,
            //     elevation: 2,
            //   )
            : const CircularProgressIndicator());
  }
}
