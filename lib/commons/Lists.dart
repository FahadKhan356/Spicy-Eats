import 'package:flutter/material.dart';
import 'package:spicy_eats/features/Favorites/Screens/FavoriteScrren.dart';
import 'package:spicy_eats/features/account/screen/accountscreen.dart';
import 'package:spicy_eats/commons/country.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';



List screens = [
//  const Center(child: HomeScreen()),
 
  const Center(child: Text("Feedback")),

  const Center(child: Text("Documents")),
  const Center(child: Text("Settings")),
];
List screen = [
  const HomeScreen(''),
  const Favoritescrren(),
  const AccountScreen(),
  const OrdersScreen(),
  // const Center(child: Text("Accont screen comming soon"))
];
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

List<String?> scheduledmeal = [
  'None',
  'Break Fast',
  'Launch',
  'Dinner',
  'Mid Night Crave'
];
List<String> cuisines = [
  'American',
  'Arabian',
  'Chinese',
  'Italian',
  'Mexican',
  'Indian',
  'Japanese',
  'Thai',
  'French',
  'Greek',
  'Spanish',
  'Korean',
  'Vietnamese',
  'Turkish',
  'Lebanese',
  'Brazilian',
  'Drinks',
  'Ethiopian',
  'Moroccan',
  'Caribbean',
  'Mediterranean',
  'Russian',
  'Cuban',
  'German',
  'British',
  'Australian',
  'Peruvian',
  'Argentinian',
  'Portuguese',
  'Swedish',
  'Egyptian',
  'Filipino',
  'Pakistani'
];

List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

List<bool> setdays = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];

Map<String, Map<String, dynamic>> openinghours = {
  "Monday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Tuesday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Wednesday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Thursday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Friday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Saturday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  },
  "Sunday": {
    "status": false,
    "opening_time": {'hours': 0, 'mins': 0},
    "opening_period": "AM",
    "closing_time": {'hours': 0, 'mins': 0},
    "closing_period": "PM"
  }
};

List<String> ampmlist = ['AM', 'PM'];

// List<Map<String, String>> countries = [
//   {
//     'name': 'Bangladesh',
//     'code': '+880',
//     'image': 'lib/assets/images/bangladesh.png'
//   },
//   {
//     'name': 'Pakistan',
//     'code': '+92',
//     'image': 'lib/assets/images/pakistan.png'
//   },
//   {'name': 'India', 'code': '+91', 'image': 'lib/assets/images/india.png'},
// ];
List<Country> countries = [
  Country(
      name: 'Bangladesh',
      code: '+880',
      image: 'lib/assets/images/bangladesh.png'),
  Country(
      name: 'Pakistan', code: '+92', image: 'lib/assets/images/pakistan.png'),
  Country(name: 'India', code: '+91', image: 'lib/assets/images/india.png'),
];
