import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/models/registershop.dart';
import 'package:spicy_eats/Register%20shop/utils/commonImageUpload.dart';
import 'package:spicy_eats/main.dart';

var rest_ui_Provider = StateProvider<String?>((ref) => null);
var registershoprepoProvider = Provider((ref) => RegisterShopRepository());
var favoriteProvider = StateProvider<Map<String, bool>>((ref) => {});

class RegisterShopRepository {
  Future<void> uploadrestaurantData({
    required restownerIDImageFolderName,
    required restLogo,
    required restLogoImagePath,
    required File? restIdImage,
    required folderName,
    required restLogoFolder,
    required imagePath,
    required String? idimagePath,
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

      String? restIdImageUrl = restIdImage != null
          ? await uploadImageToSupabaseStorage(
              imagePath: idimagePath ?? '',
              file: restIdImage,
              folderName: restownerIDImageFolderName,
            )
          : '';
      String? restLogoUrl = await uploadImageToSupabaseStorage(
          file: restLogo,
          folderName: restLogoFolder,
          imagePath: restLogoImagePath);

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
            'restLogoUrl': restLogoUrl,
          })
          .then((value) => print("Inserted successfully: $value"))
          .catchError((error) {
            print("Insert failed: $error");
          });
    } catch (e) {
      throw e.toString();
    }
  }

//fetch restaurants
  Future<List<RestaurantData>?> fetchRestaurant() async {
    try {
      List<dynamic> response =
          await supabaseClient.from('restaurants').select('*');

      if (response.isEmpty) {
        print('No restaurant data found');
        return null;
      }

      // restaurant = RestaurantData.fromJson(response);
      List<RestaurantData> restaurant = response
          .map((restauarantdata) => RestaurantData.fromJson(restauarantdata))
          .toList();
      return restaurant;
      // Return the list of RestaurantData objects
    } catch (e) {
      //throw e.toString();
      throw Exception(e);
      // print(e.toString());

      return null;
    }
  }
//fetch rest uid

  Future<List<String>?> fetchRestUid(String currentUserId) async {
    try {
      var response = await supabaseClient
          .from('restaurants')
          .select('rest_uid')
          .eq('user_id', currentUserId);
      // Extract the rest_uid from the response
      List<String> restuids = response
          .map((restaurant) => restaurant['rest_uid'] as String)
          .toList();
      return restuids;
    } catch (e) {
      print('Error fetching rest_uid: $e');
      return null; // Return null if there is an error
    }
  }

  Future<void> checkIfFavorites(
      {required String userid,
      required String restid,
      required WidgetRef ref}) async {
    try {
      final existingUser = await supabaseClient
          .from('favorites')
          .select('id')
          .eq('user_id', userid)
          .eq('rest_id', restid)
          .maybeSingle();

      ref.read(favoriteProvider.notifier).state = {
        ...ref.read(favoriteProvider),
        restid: existingUser != null,
      };
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
  }

  Future<void> togglefavorites(
      {required String userid,
      required String restid,
      required WidgetRef ref,
      required BuildContext context}) async {
    final isFav = ref.read(favoriteProvider)[restid] ?? false;
    try {
      if (isFav) {
        await supabaseClient
            .from('favorites')
            .delete()
            .eq('user_id', userid)
            .eq('rest_id', restid);
      } else {
        await supabaseClient.from('favorites').insert({
          'user_id': userid,
          'rest_id': restid,
        });
      }

      ref.read(favoriteProvider.notifier).state = {
        ...ref.read(favoriteProvider),
        restid: !isFav,
      };
    } catch (e) {
      throw Exception(e);
    }
  }
}
