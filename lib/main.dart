import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/widgets/map.dart';
import 'package:spicy_eats/Supabse%20Backend/supabase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';
import 'package:spicy_eats/features/splashscreen/SplashScreen.dart';
import 'package:spicy_eats/routes.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(url: supabaseUrl, anonKey: supabasekey);
  await dotenv.load(fileName: 'lib/.env');
  // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
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
  GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  late final StreamSubscription<AuthState> _authstateSubscription;
  late final StreamSubscription<Uri?> _linksubscription;
  final AppLinks _appLinks = AppLinks();

  _initialAuth() {
    _authstateSubscription =
        supabaseClient.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null && navigatorkey.currentState != null) {
        navigatorkey.currentState!.pushNamedAndRemoveUntil(
          Home.routename,
          (route) => false,
          arguments: ref,
        );
      }
    });
  }

  Future<void> _initializeDeeplink() async {
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        handleDeeplink(initialUri);
      }
      _linksubscription = _appLinks.uriLinkStream.listen(handleDeeplink);
    } catch (e) {
      debugPrint('Error initializing deeplink $e');
    }
  }

  Future<void> handleDeeplink(Uri uri) async {
    if (uri.host == 'login-callback') {
      try {
        supabaseClient.auth.getSessionFromUrl(uri);
      } catch (e) {
        debugPrint('Error handling deep link: $e');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _initialAuth();

    // _initializeDeeplink();
    // _authstateSubscription =
    //     supabaseClient.auth.onAuthStateChange.listen((data) {
    //   final AuthChangeEvent event = data.event;
    //   final Session? session = data.session;

    //   if (event == AuthChangeEvent.signedIn && session != null) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, Home.routename, (route) => false);
    //   }
    // });
  }
  //     supabaseClient.auth.onAuthStateChange.listen((event) {
  //   setState(() {});
  //   //   // _refreshSession();
  // });

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _authstateSubscription.cancel();
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
        home: const SplashScreen()

        // MyMap()

        // const SplashScreen()

        //SplashScreen()
        //ProfileScreen(),
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
        // supabaseClient.auth.currentSession != null
        //     ? Home()
        //     : PasswordlessScreen(ref: ref),
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
        );
  }
}
