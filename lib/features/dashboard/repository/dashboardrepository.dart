import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/utils/commonImageUpload.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
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
    required String? dishcusine,
    required String? restUid,
    required String? categoryId,
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
        'category_id': categoryId,
        'cusine': dishcusine,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Categories>?> fetchCategories() async {
    var response = await supabaseClient.from('categories').select('*');

    print(response); // Print the raw response for debugging

    try {
      if (response.isEmpty) {
        print('No categories data found');
        return null;
      }

      List<Categories> categories =
          response.map<Categories>((e) => Categories.fromJson(e)).toList();

      return categories;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> addCategory({
    required String? categoryname,
    required String? categorydiscription,
    required String? restUid,
  }) async {
    try {
      await supabaseClient.from('categories').insert({
        'category_name': categoryname,
        'category_description': categorydiscription,
        'rest_uid': restUid,
      }).then((value) {
        if (value != null) {
          print('successfully added category...');
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
