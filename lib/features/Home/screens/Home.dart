import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/main.dart';

var currentIndexProvider = StateProvider<int>((ref) => 0);

class Home extends ConsumerStatefulWidget {
  bool? isloader = false;
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
        body: screen[currentIndex],
        bottomNavigationBar: supabaseClient.auth.currentSession != null
            ? BottomNavigationBar(
                items: bitems,
                onTap: (index) {
                  ref
                      .read(currentIndexProvider.notifier)
                      .update((state) => index);
                },
                currentIndex: currentIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black38,
                elevation: 2,
              )
            : const CircularProgressIndicator());
  }
}
