import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/restaurant_model.dart';

final restaurantstateProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantModel>(
        (ref) => RestaurantNotifier());

class RestaurantNotifier extends StateNotifier<RestaurantModel> {
  RestaurantNotifier() : super(RestaurantModel());

  void setRestaurantData({
    String? restaurantName,
    double? deliveryFee,
    int? minTime,
    int? maxTime,
    double? ratings,
    String? address,
    int? phoneNumber,
    String? deliveryArea,
    String? postalCode,
    int? idNumber,
    String? description,
    double? lat,
    double? long,
    String? email,
    String? idFirstName,
    String? idLastName,
    String? idPhotoUrl,
    String? userId,
    String? paymentMethod,
    Map<String, Map<String, dynamic>>? openingHours,
    String? restaurantImageUrl,
  }) {
    state = state.copywith(
        phoneNumber: phoneNumber,
        address: address,
        restaurantName: restaurantName,
        averageRatings: ratings,
        email: email,
        lat: lat,
        long: long,
        description: description,
        deliveryFee: deliveryFee,
        minTime: minTime,
        maxTime: maxTime,
        deliveryArea: deliveryArea,
        postalCode: postalCode,
        idNumber: idNumber,
        idFirstName: idFirstName,
        idLastName: idLastName,
        // userId: newData.userId,
        idPhotoUrl: idPhotoUrl,
        openingHours: openingHours,
        paymentMethod: paymentMethod);
  }
}
