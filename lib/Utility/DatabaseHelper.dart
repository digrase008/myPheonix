import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'your_database.db';
  static const int dbVersion = 1;

  // Private constructor to prevent instantiation
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create tables and initial setup when the database is created
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
      )
    ''');
    // Create other tables as needed
  }

  // Example CRUD operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query('users');
  }

  Future<void> clearAllTables() async {
    Database db = await database;

    // List all table names you want to clear
    List<String> tables = [
      'PersonalDetails',
      'FamilyDetails',
      'LoanDetails',
      'BusinessDetails',
      'AddressDetails',
      'PropertyDetails',
      'BankingDetails',
      'InsuranceDetails'
    ]; // Add other table names

    for (String table in tables) {
      // await db.execute('DROP TABLE IF EXISTS $table');
      await db.delete(table);
    }
  }
}
