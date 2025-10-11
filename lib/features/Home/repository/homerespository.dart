import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/commons/Providers.dart';
import 'package:spicy_eats/commons/categoriesmodel.dart';
import 'package:spicy_eats/commons/mysnackbar.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/services/RestaurantLocalDataBase.dart';
import 'package:spicy_eats/main.dart';

var homeRepositoryController = Provider((ref) => HomeRepository(RestaurantLocalDatabase.instance));

class HomeRepository {
  HomeRepository(this._database);
  final RestaurantLocalDatabase _database;
  Future<List<DishData>?> fetchDishes({
    required String? restuid,
    required Ref ref,
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
      print('$dishList this is dishlist');
      // print('${ref.read(rest_ui_Provider)} this is rest uid in the homerepo');

      print(e.toString());
    }
    return null;
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

  Future<void> fetchFavorites(
      {required String userid, required WidgetRef ref}) async {
    try {
      final res = await supabaseClient
          .from('favorites')
          .select('*')
          .eq('user_id', userid);
      if (res.isNotEmpty) {
        final favs = res.map((e) => e['rest_id'] as String).toList();

        for (var eachvalue in favs) {
          ref.read(favoriteProvider.notifier).state = {
            ...ref.read(favoriteProvider),
            eachvalue: true
          };
        }
      }
    } catch (e) {
      debugPrint("Failed Fetching Favorires $e");
    }
  }

Future<List<RestaurantModel>> getRestaurantsData() async {
    // 1. Try to get cached data
    return await _database.getRestaurants();
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


  Future<List<Categories>?> fetchcategorieslist(
      {required String? restuid}) async {
    List<Categories>? categories;

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
      debugPrint(' Failed Fetching Categories : $e ');
    }
    return null;
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

//add address in supabase
  Future<void> addAddress(
      {required userId,
      required address,
      String? streetNumber,
      String? floor,
      String? label,
      String? othersDetails,
      double? lat,
      double? long,
      required context}) async {
    try {
      if (userId != null) {
        final response = await supabaseClient.from('user_address').insert({
          'userId': userId,
          'address': address,
          'streetNumber': streetNumber ?? '',
          'floor': floor ?? '',
          'label': label ?? '',
          'othersDetails': othersDetails ?? '',
          'lat': lat,
          'long': long,
        }).select();

        if (response.isNotEmpty) {
          mysnackbar(context: context, text: 'Address Added Successfully');
        }
      } else {
        mysnackbar(context: context, text: 'Please Login Your Account');
      }
    } catch (e) {
      debugPrint("Error in add address : $e");
    }
  }

//fetch user address

  Future<List<AddressModel>?> fetchAllAddress({required String userId}) async {
    try {
      List<AddressModel> allAddress;
      final response = await supabaseClient
          .from('user_address')
          .select('*')
          .eq('userId', userId);

      if (response.isNotEmpty) {
        allAddress = response.map((e) => AddressModel.fromJson(e)).toList();

        return allAddress;
      }
    } catch (e) {
      debugPrint("Error in Fetching All addresses : $e");
    }
    return null;
  }

  Future<void> updateAddress({
    required addressID,
    required address,
    required context,
    String? streetNumber,
    String? floor,
    String? label,
    String? othersDetails,
    double? lat,
    double? long,
  }) async {
    try {
      final response = await supabaseClient.from('user_address').update({
        'address': address,
        'streetNumber': streetNumber ?? '',
        'floor': floor ?? '',
        'label': label ?? '',
        'othersDetails': othersDetails ?? '',
        'lat': lat,
        'long': long,
      }).eq('id', addressID);
      if (response != null) {
        mysnackbar(context: context, text: 'Address Updated Successfully');
      }
    } catch (e) {
      debugPrint("Error in Updating  Address $e");
    }


    

  
    // }

    // Future<void> changeLastAddress(
    //     {required address, required userId, required WidgetRef ref}) async {
    //   try {
    //     await supabaseClient.from('users').upsert({
    //       'last_address': address,
    //     }).eq('id', userId);
    //   } catch (e) {
    //     debugPrint("Error in changing last address : $e");
    //   }
    //   await ref.read(profileRepoProvider).fetchuser(userId, ref);
    // }
  }
}
