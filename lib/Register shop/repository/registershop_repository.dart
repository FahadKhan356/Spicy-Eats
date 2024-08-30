import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/main.dart';

class RegisterShopRepository {
  Future<void> setrestaurantdata(RestaurantData restaurantData) async {
    supabaseClient.from('restaurants').insert(
          restaurantData.toJson(),
        );
  }
}
