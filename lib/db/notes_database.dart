import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class NotesDatabase {
  /// Thisis  global field which is instance, and it calls private constructor
  static final NotesDatabase instance = NotesDatabase._init();

  /// This is private constructor
  NotesDatabase._init();

  /// Then we creat new field for this class and type comes from sqflite package
  static Database? _database;

  /// To be able to read and write from database we need to open connection
  Future<Database> get database async {
    /// first we check if we have database at all
    if (_database != null) return _database!;

    /// ...if not we have to initialize one and creates a new fire 'notes.db'
    _database = await _initDB('notes.db');
    return _database!;
  }

  /// defining method for inintializing database, this method is called from
  ///  database method

  Future<Database> _initDB(String filePath) async {
    /// we want to store out database in our  file storage system
    /// First we crate path using getDatabasePath which comes from sqflite
    /// getDatabasePath will create database path in perticular folder on Android and iOS
    /// if we want to create it in different folder we should use package path_provider
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    /// finally we're opening database using path we got
    return await openDatabase(path);
  }
}
