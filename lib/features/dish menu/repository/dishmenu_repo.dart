import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

var dishMenuRepoProvider = Provider((ref) => DishMenuRepository());
var variationProvider = StateProvider<Map<int, Variation?>>((ref) => {});

class DishMenuRepository {
//fetch variations
  Future<List<VariattionTitleModel>?> fetchVariations(
      {required int dishid, required BuildContext context}) async {
    try {
      final response = await supabaseClient
          .from('titleVariations')
          .select(
              'id , title, isRequired, subtitle, variations(id,variation_name,variation_price,variation_id)')
          .eq('id', dishid);

      if (response.isNotEmpty) {
        final variationList =
            response.map((e) => VariattionTitleModel.fromjson(e)).toList();
        return variationList;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
