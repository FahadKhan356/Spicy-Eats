
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spicy_eats/Supabse%20Backend/supabase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:spicy_eats/commons/Responsive.dart';

import 'package:spicy_eats/features/Sqlight%20Database/Cart/services/CartLocalDatabase.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Dishes/services/DishesLocalDataBase.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/services/RestaurantLocalDataBase.dart';
import 'package:spicy_eats/features/Sqlight%20Database/onBoarding/services/OnBoardingLocalDatabase.dart';
import 'package:spicy_eats/features/authentication/authServices.dart';
import 'package:spicy_eats/features/authentication/signinscreen.dart';
import 'package:spicy_eats/features/authentication/signupscreeen.dart';

import 'package:spicy_eats/features/splashscreen/SplashScreen.dart';
import 'package:spicy_eats/routes.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


var showBottomMap = StateProvider<bool>((ref) => true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartLocalDatabase.instance.database;
  await RestaurantLocalDatabase.instance.database;
  await DishesLocalDatabase.instance.database;
  await OnBoardingLocalDatabase.instance.database;
  await LocationLocalDatabase.instance.database;
  
  // Get stored data (if any)


  

  Supabase.initialize(url: supabaseUrl, anonKey: supabasekey);
  await dotenv.load(fileName: 'lib/.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
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
//    final db = LocationLocalDatabase.instance;
//     void resetFlag()async{
// final stored = await db.getLocationWithFlag('locationData');


//   if (stored != null) {
//     // Only reset the flag, keep the last location
//     await db.setLocationWithFlag(
//       'locationData',
//        true, // reset for new session
//      stored['lastLocation'],
//     ).then((value)=>debugPrint('inside then flag value : ${stored['flag']}  Last Loocation : ${stored['lastLocation']}'));
  
//   debugPrint('flag value : ${stored['flag']}  Last Loocation : ${stored['lastLocation']}');
//   }
//   }
  GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  // late final StreamSubscription<AuthState> _authstateSubscription;
  // late final StreamSubscription<Uri?> _linksubscription;
  // final AppLinks _appLinks = AppLinks();

  // _initialAuth() {
  //   _authstateSubscription =
  //       supabaseClient.auth.onAuthStateChange.listen((event) {
  //     final session = event.session;
  //     if (session != null && navigatorkey.currentState != null) {
  //       navigatorkey.currentState!.pushNamedAndRemoveUntil(
  //         Home.routename,
  //         (route) => false,
  //         arguments: ref,
  //       );
  //     }
  //   });
  // }

  // Future<void> _initializeDeeplink() async {
  //   try {
  //     final initialUri = await _appLinks.getInitialAppLink();
  //     if (initialUri != null) {
  //       handleDeeplink(initialUri);
  //     }
  //     _linksubscription = _appLinks.uriLinkStream.listen(handleDeeplink);
  //   } catch (e) {
  //     debugPrint('Error initializing deeplink $e');
  //   }
  // }

  // Future<void> handleDeeplink(Uri uri) async {
  //   if (uri.host == 'login-callback') {
  //     try {
  //       supabaseClient.auth.getSessionFromUrl(uri);
  //     } catch (e) {
  //       debugPrint('Error handling deep link: $e');
  //     }
  //   }
  // }

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

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // _authstateSubscription.cancel();
  // }

  // Future<void> _refreshSession() async {
  //   try {
  //     await supabaseClient.auth.refreshSession();
  //   } catch (e) {
  //     print('Error refreshing session: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    
    debugPrint(MediaQuery.of(context).size.width.toString());
       debugPrint(MediaQuery.of(context).size.height.toString());
     Responsive.init(context);
    return MaterialApp(
        onGenerateRoute: generateRoutes,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            //drawerTheme: DrawerThemeData(backgroundColor: Colors.),
            tabBarTheme: const TabBarTheme(),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white)),
        home:
        // BoardingScreen(),
            //  RestaurantMenu()
            // FoodDeliveryScreen()
          //  const SignUpScreen(),
          // const SignInScreen()
          const SplashScreen()
        // RestaurantMenu()

        // PerfectBlurGlassEffect(),

        // const SplashScreen()

        //     Confirmlocation(
        //   locationResult: null,
        // ),

        // const SplashScreen()

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
