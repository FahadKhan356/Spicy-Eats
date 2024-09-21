import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/legalstuffscreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/paymentmethodescreen.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/register_restaurant.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/commons/restaurantModel.dart';
import 'package:spicy_eats/features/Basket/screens/basket.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/menu_Item_detail_screen.dart';
import 'package:spicy_eats/features/Restaurant_Menu/screens/restaurant_menu.dart';
import 'package:spicy_eats/features/authentication/otp.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RestaurantMenu.routename:
      final restaurant = settings.arguments as Restaurant;
      return MaterialPageRoute(
          builder: (_) => RestaurantMenu(restaurant: restaurant));

    case MenuItemDetailScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Dish;
        return MenuItemDetailScreen(
          dish: argument,
        );
      });
    case BasketScreen.routename:
      return MaterialPageRoute(builder: (context) {
        final argument = settings.arguments as Map;
        return BasketScreen(
            dish: argument['dish'],
            totalprice: argument['totalprice'],
            quantity: argument['quantity']);
      });

    case ShopHome.routename:
      return MaterialPageRoute(builder: (context) {
        // var index = settings.arguments as int;
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
        final arguments = settings.arguments as File;
        return PaymentMethodScreen(
          image: arguments,
        );
      });
    case OtpScreen.routename:
      return MaterialPageRoute(builder: (context) => const OtpScreen());
    case HomeScreen.routename:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case RegisterRestaurant.routename:
      return MaterialPageRoute(
          builder: (context) => const RegisterRestaurant());

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Text("there is no such page"),
        ),
      );
  }
}
