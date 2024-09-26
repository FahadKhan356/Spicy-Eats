import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/utils/commonImageUpload.dart';
import 'package:spicy_eats/main.dart';

var dashboardRepositoryProvider = Provider((ref) => DashBoardRepository());

class DashBoardRepository {
  Future<void> uploadDish({
    required String? folderName,
    required String? imagePath,
    required String? dishName,
    required String? dishdescription,
    required int? dishPrice,
    required File? dishImage,
    required String? dishDiscount,
    required String? scheduleMeal,
    required String? dishcusine,
    required String? restUid,
  }) async {
    try {
      String? dishimageUrl = await uploadImageToSupabaseStorage(
          file: dishImage, folderName: folderName!, imagePath: imagePath!);

      await supabaseClient.from('dishes').insert({
        'rest_uid': restUid,
        'dish_description': dishdescription,
        'dish_price': dishPrice,
        'dish_imageurl': dishimageUrl,
        'dish_name': dishName,
        'dish_schedule_meal': scheduleMeal,
        'cusine': dishcusine,
        'dish_discount': dishDiscount,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
