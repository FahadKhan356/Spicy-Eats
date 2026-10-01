import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:spicy_eats/features/Favorites/data/FavoritesStore.dart';
import 'package:spicy_eats/features/Favorites/model/FavoriteDish.dart';
import 'package:sqflite/sqflite.dart';

/// Local store for hearted dishes. Mirrors the cart's local-first approach so
/// favorites survive app restarts and work without a network round trip.
class FavoritesLocalDatabase implements FavoritesStore {
  static final FavoritesLocalDatabase instance = FavoritesLocalDatabase._init();
  static Database? _database;

  FavoritesLocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
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
      CREATE TABLE IF NOT EXISTS favorite_dishes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        dish_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        image TEXT,
        price REAL NOT NULL,
        discount_price REAL,
        restaurant_id TEXT,
        restaurant_name TEXT,
        is_variation INTEGER NOT NULL DEFAULT 0,
        is_veg INTEGER,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_favorite_dish ON favorite_dishes (user_id, dish_id)');
  }

  @override
  Future<List<FavoriteDish>> getFavorites(String userId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'favorite_dishes',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return rows.map(FavoriteDish.fromMap).toList();
    } catch (e) {
      debugPrint('Error Fetching Favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String userId, int dishId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'favorite_dishes',
        columns: ['id'],
        where: 'user_id = ? AND dish_id = ?',
        whereArgs: [userId, dishId],
        limit: 1,
      );
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('Error Checking Favorite: $e');
      return false;
    }
  }

  @override
  Future<int> addFavorite(FavoriteDish favorite) async {
    try {
      final db = await database;
      return await db.insert(
        'favorite_dishes',
        favorite.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error Adding Favorite: $e');
      return 0;
    }
  }

  @override
  Future<void> removeFavorite(String userId, int dishId) async {
    try {
      final db = await database;
      await db.delete(
        'favorite_dishes',
        where: 'user_id = ? AND dish_id = ?',
        whereArgs: [userId, dishId],
      );
    } catch (e) {
      debugPrint('Error Removing Favorite: $e');
    }
  }

  @override
  Future<int> clearFavorites(String userId) async {
    try {
      final db = await database;
      return await db.delete(
        'favorite_dishes',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      debugPrint('Error Clearing Favorites: $e');
      return 0;
    }
  }
}
