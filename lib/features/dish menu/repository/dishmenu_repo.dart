import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/dish%20menu/model/dishmenu_model.dart';
import 'package:spicy_eats/main.dart';

var dishMenuRepoProvider = Provider((ref) => DishMenuRepository());

class DishMenuRepository {
//fetch variations
  Future<List<DishMenuModel>?> fetchVariations(
      {required int dishid, required BuildContext context}) async {
    try {
      final response = await supabaseClient
          .from('variations')
          .select('*')
          .eq('dish_id', dishid);

      if (response.isNotEmpty) {
        final variationList =
            response.map((e) => DishMenuModel.fromjson(e)).toList();
        return variationList;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
