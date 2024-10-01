import 'package:flutter/material.dart';
import 'package:spicy_eats/features/dashboard/DrawerScreens/Menu/MenuScreen.dart';
import 'package:spicy_eats/Register%20shop/screens/shophome.dart';
import 'package:spicy_eats/Register%20shop/widgets/drawerRow.dart';
import 'package:spicy_eats/commons/country.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';

final List<DrawerRow> drawerList = [
  DrawerRow(text: 'Home', icon: Icons.home),
  DrawerRow(text: 'Feedback', icon: Icons.feedback),
  DrawerRow(text: 'Payment', icon: Icons.payment),
  DrawerRow(text: 'Menu', icon: Icons.menu_book),
  DrawerRow(text: 'Documents', icon: Icons.document_scanner),
  DrawerRow(text: 'Settings', icon: Icons.settings_applications_sharp),
];

List screens = [
  const Center(child: HomeScreen()),
  const Center(child: Text("Feedback")),
  const Center(child: Text("Payment")),
  const MenuScreen(),
  const Center(child: Text("Documents")),
  const Center(child: Text("Settings")),
];
List screen = [
  const HomeScreen(),
  const OrdersScreen(),
  ShopHome(),
  // const Center(child: Text("Accont screen comming soon"))
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
