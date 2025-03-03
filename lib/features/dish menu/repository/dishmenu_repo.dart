import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/dish%20menu/model/VariationTitleModel.dart';
import 'package:spicy_eats/main.dart';

var dishMenuRepoProvider = Provider((ref) => DishMenuRepository());
var variationProvider = StateProvider<Map<int, List<Variation>?>>((ref) => {});

class DishMenuRepository {
//fetch variations
  Future<List<VariattionTitleModel>?> fetchVariations(
      {required int dishid, required context}) async {
    try {
      final response = await supabaseClient
          .from('titleVariations')
          .select(
              'id , title, isRequired, subtitle,maxSeleted,dishid, variations(id,variation_name,variation_price,variation_id)')
          .eq('dishid', dishid);

      if (response.isNotEmpty) {
        final variationList =
            response.map((e) => VariattionTitleModel.fromjson(e)).toList();
        return variationList;
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      // throw Exception(e);
    }
  }

  Future<List<VariattionTitleModel>?> fetchTitleVariation(
    BuildContext context, {
    required var dishid,
  }) async {
    try {
      final res = await supabaseClient.from('titleVariations').select(
          'id , title, isRequired, subtitle,maxSeleted,dishid, variations(id,variation_name,variation_price,variation_id)');

      if (res.isNotEmpty) {
        final titleVariationList =
            res.map((e) => VariattionTitleModel.fromjson(e)).toList();
        return titleVariationList;
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString())));
      throw Exception(e);
    }
    return null;
  }
}
