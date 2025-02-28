import 'package:flutter/material.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/DummyBasket.dart';
import 'package:spicy_eats/Practice%20for%20cart/screens/DummyCart.dart';
import 'package:spicy_eats/SyncTabBar/home_sliver_with_scrollable_tabs.dart';
import 'package:spicy_eats/features/Home/screens/Home.dart';
import 'package:spicy_eats/features/dashboard/DrawerScreens/Menu/ineroverview.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Basket/screens/basket.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/menu_Item_detail_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'package:spicy_eats/features/authentication/otp.dart';
import 'package:spicy_eats/features/dish%20menu/dish_menu_screen.dart';
import 'package:spicy_eats/tabexample.dart/tabexample.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RestaurantMenu.routename:
      Map argument = settings.arguments as Map;
      // final restaurant = settings.arguments as Restaurant;
      // final List<DishData> dishdata = settings.arguments as List<DishData>;
      return MaterialPageRoute(
          builder: (_) => RestaurantMenu(
                restaurant: argument['restaurant'],
                //dishData: argument['dishes'],
                rest_uid: argument['rest_uid'],
              ));
    case InnerOverview.routename:
      return MaterialPageRoute(builder: (_) {
        final restuid = settings.arguments as String;
        return InnerOverview(restuid: restuid);
      });

    case MenuItemDetailScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Dish;
        return MenuItemDetailScreen(
          dish: argument,
        );
      });
    case HomeSliverWithScrollableTabs.routename:
      return MaterialPageRoute(builder: (_) {
        final argument = settings.arguments as Map;
        return HomeSliverWithScrollableTabs(
            restuid: argument['restuid'],
            restaurantdata: argument['restaurantdata']);
      });

    case BasketScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Map;
        return BasketScreen(
          dish: argument['dish'],
          totalprice: argument['totalprice'],
          quantity: argument['quantity'],
          cartlist: argument['cartlist'],
          dishes: argument['dishes'] ?? [],
        );
      });
    case DummyCart.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as String;
        return DummyCart(
          restuid: argument,
        );
      });
    case DummyBasket.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Map;
        return DummyBasket(
          // cart: argument['cart'],
          dishes: argument['dishes'],
          restuid: argument['restuid'],
          restaurantData: argument['restdata'],
        );
      });

    case Home.routename:
      return MaterialPageRoute(builder: (_) => const Home());

    case ShopHome.routename:
      return MaterialPageRoute(builder: (context) {
        return ShopHome();
      });

    case BusinessDetailsScreen.routename:
      return MaterialPageRoute(
          builder: (context) => const BusinessDetailsScreen());

    case LegalInformationScreen.routename:
      return MaterialPageRoute(builder: (context) {
        return const LegalInformationScreen();
      });
    case PaymentMethodScreen.routename:
      return MaterialPageRoute(builder: (context) {
        var restaurants = settings.arguments as List<RestaurantData>?;
        return PaymentMethodScreen(
          restaurants: restaurants!,
        );
      });
    case OtpScreen.routename:
      return MaterialPageRoute(builder: (context) => const OtpScreen());
    case HomeScreen.routename:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case RegisterRestaurant.routename:
      return MaterialPageRoute(
          builder: (context) => const RegisterRestaurant());

    case MyFinalScrollScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Map;

        return MyFinalScrollScreen(
          restuid: argument['restuid'],
          restaurantData: argument['restaurantdata'],
        );
      });

    //DishMenuScreen
    case DishMenuScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as DishData;
        return DishMenuScreen(
          dish: argument,
        );
      });
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Text("there is no such page"),
        ),
      );
  }
}
