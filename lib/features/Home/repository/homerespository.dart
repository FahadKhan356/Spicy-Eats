import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/Register%20shop/repository/registershop_repository.dart';
import 'package:spicy_eats/SyncTabBar/categoriesmodel.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/main.dart';

var homeRepositoryController = Provider((ref) => HomeRepository());

class HomeRepository {
  Future<List<DishData>?> fetchDishes({
    required String? restuid,
    required ProviderRef ref,
  }) async {
    List<DishData>? dishList;
    try {
      List<dynamic> response = await supabaseClient
          .from('dishes')
          .select('*')
          .eq('rest_uid', restuid!);
      if (response.isEmpty) {
        print('there is no dishes');
        return null;
      }
      dishList =
          response.map((dishdata) => DishData.fromJson(dishdata)).toList();

      return dishList;
    } catch (e) {
      print('${dishList} this is dishlist');
      print('${ref.read(rest_ui_Provider)} this is rest uid in the homerepo');

      print(e.toString());
    }
  }

  Future<List<Categories>?> fetchcategorieslist(
      {required String? restuid}) async {
    List<Categories>? categories;
    if (restuid == null) {
      print('$restuid its null');
    } else {
      print('$restuid rest uid value');
    }
    try {
      List<dynamic> response = await supabaseClient
          .from('categories')
          .select('*')
          .eq('rest_uid', restuid!);
      if (response.isEmpty) {
        print('there is no any category related to u r restaurant');
        return null;
      }
      categories = response.map((e) => Categories.fromjson(e)).toList();
      return categories;
    } catch (e) {
      print('${e} this is categories');
      //print('${ref.read(rest_ui_Provider)} this is rest uid in the homerepo');

      print('$e....we are in fetchcategories catch block');
    }
  }

  Future<void> addRatings(
      {required BuildContext context,
      required String restid,
      required String userid,
      required double ratings}) async {
    try {
      final result = await supabaseClient
          .from('restaurants_ratings')
          .select('id')
          .eq('restid', restid)
          .eq('user_id', userid)
          .maybeSingle();

      if (result != null) {
        await supabaseClient.from('restaurants_ratings').update({
          'user_id': userid,
          'restid': restid,
          'ratings': ratings,
        }).eq('restid', restid);
      } else {
        await supabaseClient.from('restaurants_ratings').insert({
          'user_id': userid,
          'restid': restid,
          'ratings': ratings,
        }).eq('restid', restid);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> calculateAverageRatingsWithUpdate({
    required BuildContext context,
    required String restid,
  }) async {
    double? averageRatings;
    int totalRatings;
    try {
      final response = await supabaseClient
          .from('restaurants_ratings')
          .select('ratings')
          .eq('restid', restid);

      if (response.isNotEmpty) {
        final ratings =
            response.map((r) => (r['ratings'] as num).toDouble()).toList();
        averageRatings = ratings.reduce((value, element) => value + element) /
            ratings.length;
        totalRatings = ratings.length;

        await supabaseClient.from('restaurants').update({
          'average_ratings': averageRatings,
          'total_ratings': totalRatings,
        }).eq('rest_uid', restid);
        print(
            'Average Ratings (before update): $averageRatings (Type: ${averageRatings.runtimeType})');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString()))
      //     );
      throw Exception(e);
    }
  }
}
