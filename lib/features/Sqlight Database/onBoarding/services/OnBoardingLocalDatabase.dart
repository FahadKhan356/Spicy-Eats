import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OnBoardingLocalDatabase{

static final OnBoardingLocalDatabase instance = OnBoardingLocalDatabase._init();
static Database? _database;
OnBoardingLocalDatabase._init();


Future<Database> get database async{
  if(_database!=null) return _database!;
  _database=await _initDb('settings.db');
  return _database!;
}




Future<Database>_initDb(String filePath)async{
  final path=join(await getDatabasesPath(),'settings.db');
  return await openDatabase(path, version:1,onCreate:  _onCreate);
}


Future _onCreate(db,version)async{
  await db.execute('''
CREATE TABLE settings(
key TEXT PRIMARY KEY,
value TEXT NOT NULL

)''');
}

Future<void>setFlag(String key, bool value)async{
  final db= await database;
  await db.insert('settings',
  {
    'key':key,
    'value':value?'1':'0'
  },
  conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


Future<bool>getFlag(String value)async{
  final db=await database;
  final result = await db.query('settings', where: 'key=?',whereArgs:[value]);
  if(result.isNotEmpty){
    return (result.first['value']) =='1';
  }
  return false;
}


}


class LocationLocalDatabase{
static final LocationLocalDatabase instance = LocationLocalDatabase._init();

static Database? _database;
LocationLocalDatabase._init();

Future<Database> get database async {
  if(_database!=null)  return  _database!;
   _database=await _initDB('Location.db');
   return _database!;
}

  Future<Database>_initDB(String filePath) async{
    final path = join(await getDatabasesPath(), filePath);
   return await openDatabase(path,version: 1,onCreate:  _onCreateDB);
   
  }




  FutureOr<void> _onCreateDB(Database db, int version) async{
    db.execute('''
CREATE TABLE Locations(
key TEXT PRIMARY KEY,
value TEXT NOT NULL,
lastLocation TEXT

)''');

  }

  Future<void> setLocationWithFlag(String key, bool value, String lastLocation)async{
    final db = await database;
    await db.insert('Locations',{
      'key':key,
      'value':value?'1' : '0',
      'lastLocation':lastLocation
    },
     conflictAlgorithm: ConflictAlgorithm.replace,
     );
    
  }


  Future<Map<String,dynamic>?> getLocationWithFlag(String key)async{
final db = await database;
final result = await db.query('Locations', where: 'key=?', whereArgs: [key]);
if(result.isNotEmpty){
 
 return {
   'flag': (result.first['value']=='1'),
   'lastLocation':result.first['lastLocation'],
 };
}
return  null;

  }

Future<void> clear()async{
  final db = await database;
  await db.delete('Locations');
}

}