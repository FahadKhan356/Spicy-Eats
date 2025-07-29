import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:spicy_eats/Practice%20for%20cart/model/Cartmodel.dart';
import 'package:sqflite/sqflite.dart';

class CartLocalDatabase {
  static final CartLocalDatabase instance = CartLocalDatabase._init();
  static Database? _database;

  CartLocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(await getDatabasesPath(), 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(db, version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cart_id TEXT,
        user_id TEXT NOT NULL,
        dish_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        tprice REAL,
        created_at TEXT NOT NULL,
        image TEXT,
        itemprice REAL NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        variation TEXT,  
        frequently_boughtList TEXT  
      )
    ''');
  }

//Update Cart Database Sqlight

  Future<int> updateCartItem(Cartmodel item) async {
    final db = await _database!.database;
    return await db.update('cart_items', item.tojson(),
        where: 'id=?', whereArgs: [item.cart_id]);
  }

  //Add New Cart Item Database Sqlight

  Future<int> insertCartItem(Cartmodel item) async {
    try {
      final db = await _database!.database;
      return await db.insert('cart_items', item.tojson());
    } catch (e) {
      debugPrint('Error in Inseting Cart Item $e');
      return 0;
    }
  }

//Delete Cart Item Database Sqlight
  Future<void> deleteCartItem(id) async {
    final db = _database!.database;
    await db.delete('cart_items', where: 'id=?', whereArgs: [id]);
  }

//Clear Up Cmplete Data From Cart Table Sqlight
  Future<int> clearCart() async {
    final db = await database;
    return await db.delete('cart_items'); // Deletes all rows
  }

//Function For Completely Retrieve Cart Data From Local Database
  Future<List<Cartmodel>> getCartItems(String userId) async {
    try {
      final db = await _database?.database;
      final maps = await db?.query(
        'cart_items',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return maps!.map((map) => Cartmodel.fromjson(map)).toList();
    } catch (e) {
      debugPrint('Error Fetching Cart: $e');
      return [];
    }
  }
}
