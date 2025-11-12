
import 'package:spicy_eats/features/Home/model/restaurant_model.dart';

class CachedRestaurant {
  final List<RestaurantModel> restaurants;
  final DateTime timestamp;

  CachedRestaurant({
    required this.restaurants,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurants': restaurants.map((r) => r.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CachedRestaurant.fromJson(Map<String, dynamic> json) {
    return CachedRestaurant(
      restaurants: (json['restaurants'] as List)
          .map((r) => RestaurantModel.fromJson(r))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
