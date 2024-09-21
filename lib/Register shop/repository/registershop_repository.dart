import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/main.dart';

var rest_ui_Provider = StateProvider<String?>((ref) => null);
var registershoprepoProvider = Provider((ref) => RegisterShopRepository());

class RegisterShopRepository {
  Future<void> uploadrestaurantData({
    required restName,
    required address,
    required deliveryArea,
    required postalCode,
    required description,
    required businessEmail,
    required idFirstName,
    required idLastname,
    required idPhotoUrl,
    required restImgUrl,
    required deliveryFee,
    required long,
    required lat,
    required minTime,
    required maxTime,
    required phoneNumber,
    required idNumber,
    required Map<String, Map<String, dynamic>> openingHours,
  }) async {
    try {
      await supabaseClient
          .from('restaurants')
          .insert({
            'restaurantName': restName,
            'deliveryFee': deliveryFee,
            'minTime': minTime,
            'maxTime': maxTime,
            'address': address,
            'phoneNumber': phoneNumber,
            'deliveryArea': deliveryArea,
            'postalCode': postalCode,
            'idNumber': idNumber,
            'description': description,
            'long': long,
            'lat': lat,
            'businessEmail': businessEmail,
            'idFirstName': idFirstName,
            'idLastName': idLastname,
            'openingHours': openingHours,
            'restaurantImageUrl': restImgUrl,
            'idPhotoUrl': idPhotoUrl,
          })
          .then((value) => print("Inserted successfully: $value"))
          .catchError((error) {
            print("Insert failed: $error");
          });
    } catch (e) {
      print('Exception during insert');
      print(e.toString());
    }
  }

//fetch restaurants
  Future<RestaurantData?> fetchRestaurant(String? currentUserId) async {
    try {
      RestaurantData? restaurant;
      var response = await supabaseClient
          .from('restaurants')
          .select('*')
          .eq('user_id', currentUserId!)
          .single();
      restaurant = RestaurantData.fromJson(response);
      return restaurant;
      // rest_name = restaurant?.restaurantName;
    } catch (e) {
      throw e.toString();
    }
  }
//fetch rest uid

  Future<String?> fetchRestUid(String currentUserId) async {
    try {
      var response = await supabaseClient
          .from('restaurants')
          .select('rest_uid')
          .eq('user_id', currentUserId)
          .single();

      // Extract the rest_uid from the response
      var restUid = response['rest_uid'] as String?;
      return restUid;
    } catch (e) {
      print('Error fetching rest_uid: $e');
      return null; // Return null if there is an error
    }
  }
}
