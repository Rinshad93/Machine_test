import 'package:machine_test/models/cartData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "cart.db";
  static final _databaseVersion = 3;

  static final table = 'cart';

  static const String TABLE_CART = "cart";
  static const String COLUMN_ID = "id";
  static const String COLUMN_ITEM_NAME = "item";
  static const String COLUMN_ITEM_ID = "dish_id";
  static const String COLUMN_CALORIES = "calories";
  static const String COLUMN_QUANTITY = "quantity";
  static const String COLUMN_PRICE = "price";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    
    
    
    CREATE TABLE $TABLE_CART (
          $COLUMN_ID INTEGER PRIMARY KEY,
          $COLUMN_ITEM_ID TEXT,
          $COLUMN_ITEM_NAME TEXT,
          $COLUMN_CALORIES DOUBLE,
          $COLUMN_QUANTITY INTEGER,
          $COLUMN_PRICE DOUBLE)
    
  
          ''');
  }

  Future<int> insert(Cart cart) async {
    Database db = await instance.database;
    var res = await db.insert(table, cart.toMap());
    return res;
  }

  Future<int> update(Cart cart) async {
    Database db = await instance.database;
    var res = await db.update(table, cart.toMap(),
        where: '$COLUMN_ITEM_ID = ?', whereArgs: [cart.dishId]);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$COLUMN_ID DESC");
    return res;
  }

  Future<int> delete(Cart cart) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$COLUMN_ITEM_ID = ?', whereArgs: [cart.dishId]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}
