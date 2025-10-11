import 'package:flutter_riverpod/flutter_riverpod.dart';

var isMapPickProvider = StateProvider<bool>((ref) => false);
var restaurantLatProvider = StateProvider<double?>((ref) => null);
var restaurantLongProvider = StateProvider<double?>((ref) => null);
var restaurantAddProvider = StateProvider<String?>((ref) => null);
var restaurantEmailProvider = StateProvider<String?>((ref) => null);
var restaurantNameProvider = StateProvider<String?>((ref) => null);
final restaurantPhoneNumberProvider = StateProvider<int?>((ref) => 0);
var favoriteProvider = StateProvider<Map<String, bool>>((ref) => {});