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
