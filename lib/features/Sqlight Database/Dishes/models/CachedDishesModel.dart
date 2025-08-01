import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';

class CachedDishesModel {
  CachedDishesModel(
      {required this.dishes,
      required this.timestamp,
      required this.restaurantUid});

  final List<DishData> dishes;
  final DateTime timestamp;
  final String restaurantUid;

//toJson
  Map<String, dynamic> toJson() {
    return {
      "dishes": dishes.map((e) => e.tojson()).toList(),
      "timestamp": timestamp.millisecondsSinceEpoch,
      "restaurantUid": restaurantUid,
    };
  }

//fromJson

  factory CachedDishesModel.fromJson(Map<String, dynamic> json) {
    return CachedDishesModel(
        dishes:
            (json['dishes'] as List).map((e) => DishData.fromJson(e)).toList(),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        restaurantUid: json['restaurantUid'] as String);
  }
}
