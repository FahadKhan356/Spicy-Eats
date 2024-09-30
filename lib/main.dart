import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/dashboard/DrawerScreens/Menu/SubScreens/AddItemScreen.dart';
import 'package:spicy_eats/Register%20shop/dashboard/DrawerScreens/Menu/overview.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/Register%20shop/widgets/Lists.dart';
import 'package:spicy_eats/Register%20shop/widgets/TimePicker.dart';
import 'package:spicy_eats/Supabse%20Backend/supabase_config.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:spicy_eats/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// final currentIndexProvider = StateProvider((ref) => 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(url: supabaseUrl, anonKey: supabasekey);
  runApp(const ProviderScope(child: MyApp()));
}

final supabaseClient = Supabase.instance.client;

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

int currentindex = 0;

class _MyAppState extends ConsumerState<MyApp> {
  late final StreamSubscription<AuthState> _authstateSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authstateSubscription =
        supabaseClient.auth.onAuthStateChange.listen((event) {
      setState(() {});
      // _refreshSession();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _authstateSubscription.cancel();
  }

  Future<void> _refreshSession() async {
    try {
      await supabaseClient.auth.refreshSession();
    } catch (e) {
      print('Error refreshing session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bitems = [
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 40,
          ),
          label: ''),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.delivery_dining,
            size: 40,
          ),
          label: ''),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.account_box,
            size: 40,
          ),
          label: ''),
    ];

    return MaterialApp(
        onGenerateRoute: generateRoutes,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: Scaffold(
            body: supabaseClient.auth.currentSession != null
                ? screen[currentindex]
                : PasswordlessScreen(
                    ref: ref,
                  ),
            //AddItemScreen(),
            //supabaseClient.auth.currentSession != null
            //     ? screen[currentindex]
            //     : PasswordlessScreen(
            //         ref: ref,
            //       ),
            //AddItemScreen(),
            //supabaseClient.auth.currentSession != null
            //     ? screen[currentindex]
            //     : PasswordlessScreen(
            //         ref: ref,
            //       ),
            //TimePicker(),

            //Shapes(),
            //TimePicker(),
            // supabaseClient.auth.currentSession != null
            //     ? screen[currentindex]
            //     : PasswordlessScreen(
            //         ref: ref,
            //       ),
            bottomNavigationBar: supabaseClient.auth.currentSession != null
                ? BottomNavigationBar(
                    items: bitems,
                    onTap: (index) {
                      setState(() {
                        currentindex = index;
                      });
                    },
                    currentIndex: currentindex,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.black38,
                    elevation: 2,
                  )
                : null));
  }
}
