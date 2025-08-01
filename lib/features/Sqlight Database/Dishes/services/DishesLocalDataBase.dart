import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:spicy_eats/features/Restaurant_Menu/model/dish.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Dishes/models/CachedDishesModel.dart';
import 'package:spicy_eats/main.dart';
import 'package:sqflite/sqflite.dart';

class DishesLocalDatabase {
  static final DishesLocalDatabase instance = DishesLocalDatabase._init();

  static Database? _database;

  DishesLocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Dishes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, version) async {
    await db.execute('''
   CREATE TABLE IF NOT EXISTS cache_dish (
      restaurant_uid TEXT PRIMARY KEY,
      dish_data TEXT NOT NULL,
      timestamp INTEGER NOT NULL
    )

''');
  }

  static const Duration cacheTTL = Duration(hours: 1);

//Get Dishes Data
  Future<List<DishData>?> getDishes(String restaurantUid) async {
    try {
      final cachedData = await getDishesCachedData(restaurantUid);
      if (cachedData != null &&
          DateTime.now().difference(cachedData.timestamp) < cacheTTL) {
        debugPrint("Dishes Time Not Expired");
        return cachedData.dishes;
      }
      debugPrint("Dishes Time Expired");

      final fresh = await _fetchFromSupabase(restaurantUid);

      await cacheDishesData(restaurantUid, fresh);
      return fresh;
    } catch (e) {
      debugPrint("Failed To Fetch Dishes Data $e");
    }

    return null;
  }

//Fetch Dishes Data From Local Database Sqlight
  Future<CachedDishesModel?> getDishesCachedData(String restaurantUid) async {
    try {
      final json = await getCachedData(restaurantUid);
      if (json != null) {
        return CachedDishesModel.fromJson(json);
        // return CachedDishesModel.fromJson({
        //   'restaurant_uid': restaurantUid,
        //   'dishes': json['dishes'],
        //   'timestamp': json['timestamp'],
        // });
      }
    } catch (e) {
      debugPrint("Failed to fetch Dish Cached Data $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCachedData(String restaurantUid) async {
    final db = await database;
    final result = await db.query(
      'cache_dish',
      where: 'restaurant_uid=?',
      whereArgs: [restaurantUid],
      limit: 1,
    );
    if (result.isNotEmpty)
      return jsonDecode(result.first['dish_data'] as String);

    return null;
  }

//Fetch From Supabase
  Future<List<DishData>> _fetchFromSupabase(String restaurantUid) async {
    try {
      final response = await supabaseClient
          .from("dishes")
          .select('*')
          .eq('rest_uid', restaurantUid);

      final result = response.map((e) => DishData.fromJson(e)).toList();
      return result;
    } catch (e) {
      debugPrint("Failed to Fetch Dishes Data From Supabase $e");
      throw Exception(e);
    }
  }

//Cache Dishes Data In Local DataBase Sqlight

  Future<void> cacheDishesData(String restUid, List<DishData> dishes) async {
    final cache = CachedDishesModel(
        dishes: dishes, timestamp: DateTime.now(), restaurantUid: restUid);
    await cahedData(restUid, cache.toJson());
  }

  Future cahedData(String restUid, Map<String, dynamic> map) async {
    final db = await database;
    db.insert(
      'cache_dish',
      {
        'restaurant_uid': restUid,
        'dish_data': jsonEncode(map),
        'timestamp': DateTime.now().millisecondsSinceEpoch
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
