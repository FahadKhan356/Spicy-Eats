import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/main.dart';

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
}
