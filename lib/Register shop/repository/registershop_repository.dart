import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/screens/Sign_in&up%20Restaurant/screens/businessInformation.dart';
import 'package:spicy_eats/Register%20shop/utils/commonImageUpload.dart';
import 'package:spicy_eats/main.dart';

var rest_ui_Provider = StateProvider<String?>((ref) => null);
var registershoprepoProvider = Provider((ref) => RegisterShopRepository());

class RegisterShopRepository {
  Future<void> uploadrestaurantData({
    required restownerIDImageFolderName,
    required File restIdImage,
    required folderName,
    required imagePath,
    required idimagePath,
    required File restImage,
    required restName,
    required address,
    required deliveryArea,
    required postalCode,
    required description,
    required businessEmail,
    required idFirstName,
    required idLastname,
    required idPhotoUrl,
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
      String? restImageUrl = await uploadImageToSupabaseStorage(
        imagePath: imagePath,
        file: restImage,
        folderName: folderName,
      );

      String? restIdImageUrl = await uploadImageToSupabaseStorage(
        imagePath: idimagePath,
        file: restIdImage,
        folderName: restownerIDImageFolderName,
      );

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
            'restaurantImageUrl': restImageUrl,
            'idPhotoUrl': restIdImageUrl,
          })
          .then((value) => print("Inserted successfully: $value"))
          .catchError((error) {
            print("Insert failed: $error");
          });
    } catch (e) {
      throw e.toString();
      //print('Exception during insert');
      //print(e.toString());
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
      //throw e.toString();
      print('No restaurant data');
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
