import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:spicy_eats/commons/restaurant_model.dart';
import 'package:spicy_eats/features/Sqlight%20Database/Restaurants/model/CachedRestauartsModel.dart';
import 'package:spicy_eats/main.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantLocalDatabase {
  static final RestaurantLocalDatabase instance =
      RestaurantLocalDatabase._init();

  RestaurantLocalDatabase._init();

  static Database? _database;

//
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('restauran.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
   CREATE TABLE cache (
        key TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )

  ''');
  }

// TTL duration - 2 hours
  static const Duration cacheTTL = Duration(hours: 2);

// Fetch Fresh Data From Supabase
  Future<List<RestaurantModel>> _fetchFromSupabase() async {
    try {
      final response = await supabaseClient.from('restaurants').select('*');
      return response.map((data) => RestaurantModel.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Supabase fetch error: $e');
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    // 1. Try to get cached data
    final cached = await _getCachedRestaurants();

    // 2. Return cached data if fresh
    if (cached != null &&
        DateTime.now().difference(cached.timestamp) < cacheTTL) {
      debugPrint(" Time Not Expired");
      return cached.restaurants;
    }
    debugPrint(" Time Expired");
    // 3. Fetch fresh data from Supabase
    final freshData = await _fetchFromSupabase();

    // 4. Cache the fresh data
    await _cacheRestaurants(freshData);

    return freshData;
  }

  Future<CachedRestaurant?> _getCachedRestaurants() async {
    try {
      final json = await getCachedData('restaurants');
      if (json != null) {
        return CachedRestaurant.fromJson(json);
      }
    } catch (e) {
      debugPrint('Error reading cache: $e');
    }
    return null;
  }

  Future<void> _cacheRestaurants(List<RestaurantModel> restaurants) async {
    final cache = CachedRestaurant(
      restaurants: restaurants,
      timestamp: DateTime.now(),
    );
    await cacheData('restaurants', cache.toJson());
  }

  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'cache',
      {
        'key': key,
        'data': jsonEncode(data),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedData(String key) async {
    final db = await database;
    final result = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (result.isNotEmpty) {
      return jsonDecode(result.first['data'] as String);
    }
    return null;
  }
}
