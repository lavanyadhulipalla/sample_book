import 'package:sample_book/data/local/book_local_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookDatabaseHelper {
  static final BookDatabaseHelper _instance = BookDatabaseHelper._internal();
  factory BookDatabaseHelper() => _instance;
  BookDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(title TEXT, workKey TEXT PRIMARY KEY)',
        );
      },
    );
  }

  Future<void> insertBook(BookLocalModel book) async {
    final db = await database;
    await db.insert('books', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BookLocalModel>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return maps.map((map) => BookLocalModel.fromMap(map)).toList();
  }

  Future<void> deleteBook(String workKey) async {
    final db = await database;
    await db.delete('books', where: 'workKey = ?', whereArgs: [workKey]);
  }
}