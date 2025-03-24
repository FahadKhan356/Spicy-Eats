import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';

import 'package:spicy_eats/Supabse%20Backend/supabase_config.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';

import 'package:spicy_eats/routes.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

// final currentIndexProvider = StateProvider((ref) => 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(url: supabaseUrl, anonKey: supabasekey);
  // debugPaintSizeEnabled = true;
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
    return MaterialApp(
        onGenerateRoute: generateRoutes,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            //drawerTheme: DrawerThemeData(backgroundColor: Colors.),
            tabBarTheme: TabBarTheme(),
            appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
        home: Scaffold(
          body:
              // PaymentScreen()
              //  AnimatedAddButton()
              // DishMenuScreen(),
              //MyFinalScrollScreen(),
              //MyCustomSliverScreen(),
              //CustomScrollTransition(),
              //Mian_rappi_concept_app(),
              // SliverAppBarWithDynamicTabs()
              // QuantityButton1(),

              //BasketScreen(dish: null, totalprice: 122, quantity: 2),
              supabaseClient.auth.currentSession != null
                  ? Home()
                  : PasswordlessScreen(ref: ref),
          // supabaseClient.auth.currentSession != null
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
        ));
  }
}
