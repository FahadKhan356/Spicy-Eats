import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spicy_eats/Practice%20for%20cart/model/.dart';
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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
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
        variation_id INTEGER,
        variations TEXT,  // JSON string for variations
        freqboughts TEXT   // JSON string for freqboughts
      )
    ''');
  }

//Update Cart Database Sqlight

  Future<int> updateCartItem(CartModel item) async {
    final db = await _database!.database;
    return await db.update('cart_items', item.tojson(),
        where: 'id=?', whereArgs: [item.cart_id]);
  }
}
