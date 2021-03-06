import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlflite_note_app/models/note.dart';

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
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// This methot creates database and here we define how this database is gonna look like
  /// This method is only executed if there is no 'notes.db' file in the file system
  FutureOr<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // This is SQL identifier
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType,
    )
    ''');

    ///NOTE WE CAN CREATE MANY DATABASE TABLES
  }

  /// Like name says this one will create note in database
  /// WRITING NOTE!!!
  Future<Note> create(Note note) async {
    ///Step 1: Get the reference of the database
    final db = await instance.database;

    /// Step 2: calling db on insert that takes name ot the table and map (that we got from note.toJson)
    /// This id is generated by database and it have to be unique
    /// We can pass our own id if we want but if we don't than database will generate it for us
    final id = await db.insert(tableNotes, note.toJson());

    /// Step 3:
    return note.copyWith(id: id);
  }

  /// READING NOTE!!!!
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    /// maps is list of maps (actuallu Json) and now we need to convert it to Note object
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id}=?', // we can put id instead of ? but it's not safe
      whereArgs: [id], // this is instead of question mark
    );

    /// now we have to check it our request returned some value
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id $id is not found');
    }
  }

  ///This method is used when you want to read multiple notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    /// This will order items by ascending order
    final orderBy = '${NoteFields.time} ASC';

    /// This time we're not asking for specific object but we're quering whole list
    /// of objects
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id}=?',
      whereArgs: [note.id],
    );

    /// If we want to use SQL statement directly we can use next line.
    /// It will do the same as db.update but with lets say SQL syntax
    //db.rawUpdate('Here we place SQL querry')
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return db.delete(
      tableNotes,
      where: '${NoteFields.id}=?',
      whereArgs: [id],
    );
  }

  /// This method is used for closing database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
