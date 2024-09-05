import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';

final restaurantstateProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantData>(
        (ref) => RestaurantNotifier());

class RestaurantNotifier extends StateNotifier<RestaurantData> {
  RestaurantNotifier() : super(RestaurantData());

  void setRestaurantData(RestaurantData newData) {
    state = state.copywith(
        phoneNumber: newData.phoneNumber,
        address: newData.address,
        restaurantName: newData.restaurantName,
        ratings: newData.ratings,
        email: newData.email,
        lat: newData.lat,
        long: newData.long,
        description: newData.description,
        deliveryFee: newData.deliveryFee,
        minTime: newData.minTime,
        maxTime: newData.maxTime,
        deliveryArea: newData.deliveryArea,
        postalCode: newData.postalCode,
        idNumber: newData.idNumber,
        idFirstName: newData.idFirstName,
        idLastName: newData.idLastName,
        // userId: newData.userId,
        idPhotoUrl: newData.idPhotoUrl,
        openingHours: newData.openingHours,
        paymentMethod: newData.paymentMethod);
  }
}
