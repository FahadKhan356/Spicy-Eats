import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/map.dart';
import 'package:spicy_eats/commons/ConfirmLocation.dart';
import 'package:spicy_eats/commons/routeAnimation.dart';
import 'package:spicy_eats/features/Basket/screens/BasketScreen.dart';
import 'package:spicy_eats/features/Favorites/Screens/FavoriteScrren.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/Payment/PaymentScreen.dart';
import 'package:spicy_eats/features/Profile/commons/EditScreen.dart';
import 'package:spicy_eats/features/Profile/screen/ProfileScreen.dart';
import 'package:spicy_eats/features/account/screen/accountscreen.dart';
import 'package:spicy_eats/features/authentication/passwordless_signup.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/authentication/otp.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/features/dish%20menu/dishmenuVAriation.dart';
import 'package:spicy_eats/features/onBoarding/screen/BoardingScreen.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/RestaurantMenuScreen.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case MyMap.routename:
      return MaterialPageRoute(builder: (_) {
        bool argument = settings.arguments as bool;
        return MyMap(
          isAddScreen: argument,
        );
      });
    // case RestaurantMenu.routename:
    //   Map argument = settings.arguments as Map;
    //   // final restaurant = settings.arguments as Restaurant;
    //   // final List<DishData> dishdata = settings.arguments as List<DishData>;
    //   return MaterialPageRoute(
    //       builder: (_) => RestaurantMenu(
    //             restaurant: argument['restaurant'],
    //             //dishData: argument['dishes'],
    //             rest_uid: argument['rest_uid'],
    //           ));
    // case InnerOverview.routename:
    //   return MaterialPageRoute(builder: (_) {
    //     final restuid = settings.arguments as String;
    //     return InnerOverview(restuid: restuid);
    //   });

    case Confirmlocation.routename:
      return MaterialPageRoute(builder: (_) {
        final argument = settings.arguments as Map;
        return Confirmlocation(
          locationResult: argument['locationResult'],
          isEdit: argument['isEdit'] ?? false,
          addressmodel: argument['addressModel'],
        );
      });
    // case MenuItemDetailScreen.routename:
    //   return MaterialPageRoute(builder: (context) {
    //     final argument = settings.arguments as Dish;
    //     return MenuItemDetailScreen(
    //       dish: argument,
    //     );
    //   });
 
    
    case BasketScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Map;
        return BasketScreen(
          // cart: argument['cart'],
          dishes: argument['dishes'],

          restaurantData: argument['restdata'],
        );
      });

    case Home.routename:
      return MaterialPageRoute(builder: (_) => Home());

   
    case OtpScreen.routename:
      return MaterialPageRoute(builder: (context) => const OtpScreen());
    case HomeScreen.routename:
      return MaterialPageRoute(builder: (context) => const HomeScreen(''));


    // case MyFinalScrollScreen.routename:
    //   return MaterialPageRoute(builder: (context) {
    //     final argument = settings.arguments as Map;

    //     return MyFinalScrollScreen(
    //       restuid: argument['restuid'],
    //       restaurantData: argument['restaurantdata'],
    //     );
    //   });

    //DishMenuScreen
    case DishMenuScreen.routename:
      // return MaterialPageRoute(builder: (context) {
      final argument = settings.arguments as Map;
      return customRouteAnimation(
        DishMenuScreen(
          dish: argument['dish'],
          isCart: argument['iscart'],
          cartDish: argument['cartdish'],
          isdishscreen: argument['isdishscreen'],
          restaurantData: argument['restaurantdata'],
        ),
      );
    // });
    case DishMenuVariation.routename:
      final argument = settings.arguments as Map;
      return customRouteAnimation(
        DishMenuVariation(
          dishes: argument['dishes'],
          dish: argument['dish'],
          isCart: argument['iscart'],
          restaurantData: argument['restaurantdata'],
          cartDish: argument['cartdish'],
          isdishscreen: argument['isdishscreen'],
          carts: argument['carts'],
        ),
      );
    case PaymentScreen.routename:
      return customRouteAnimation(const PaymentScreen());

    case RestaurantMenuScreen.routename:
      final restaurantData = settings.arguments as RestaurantModel;
      return customRouteAnimation(
          RestaurantMenuScreen(restaurantData: restaurantData));

    case ProfileScreen.routename:
      return MaterialPageRoute(builder: (_) => ProfileScreen());

    case EditScreen.routname:
      return MaterialPageRoute(builder: (_) {
        final argument = settings.arguments as String;
        return EditScreen(editType: argument);
      });

    case PasswordlessScreen.routename:
      return MaterialPageRoute(builder: (_) {
        final ref = settings.arguments as WidgetRef;
        return PasswordlessScreen(ref: ref);
      });

case BoardingScreen.routename:
return MaterialPageRoute(builder:(context)=>const BoardingScreen());


    case OrdersScreen.routename:
      return MaterialPageRoute(builder: (context) => const OrdersScreen());

    case Favoritescrren.routename:
      return MaterialPageRoute(builder: (context) => const Favoritescrren());
 

    case AccountScreen.routename:
      return MaterialPageRoute(builder: (_) => const AccountScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Text("there is no such page"),
        ),
      );
  }
}
