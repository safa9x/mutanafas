import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _db;

  DatabaseHelper._init();

  // ================= GET DB =================
  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB('mutanafas.db');

    return _db!;
  }

  // ================= INIT DB =================
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // ================= CREATE DATABASE =================
  Future<void> _createDB(Database db, int version) async {
    // ================= WORSHIPS TABLE =================
    await db.execute('''
      CREATE TABLE worships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        iconCode INTEGER NOT NULL
      )
    ''');

    // ================= JOURNALS TABLE =================
    await db.execute('''
      CREATE TABLE journals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // ================= BREATHING TABLE =================
    await db.execute('''
      CREATE TABLE breathing_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        duration INTEGER NOT NULL,
        sessionType TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await _insertDailyWorships(db);
  }

  // ================= DEFAULT DATA =================
  Future<void> _insertDailyWorships(Database db) async {
    final today = _today();

    final items = [
      {
        'name': 'أذكار الصباح',
        'description': 'ابدأ يومك بذكر الله وراحة القلب',
        'type': 'ذكر',
        'date': today,
        'isCompleted': 0,
        'iconCode': 0,
      },
      {
        'name': 'أذكار المساء',
        'description': 'اختم يومك بالسكينة والاستغفار',
        'type': 'ذكر',
        'date': today,
        'isCompleted': 0,
        'iconCode': 1,
      },
      {
        'name': 'صلاة الضحى',
        'description': 'باب رزق وبركة في يومك',
        'type': 'صلاة',
        'date': today,
        'isCompleted': 0,
        'iconCode': 2,
      },
      {
        'name': 'ورد القرآن',
        'description': 'قرب من كلام الله كل يوم',
        'type': 'قرآن',
        'date': today,
        'isCompleted': 0,
        'iconCode': 3,
      },
      {
        'name': 'صلاة القيام',
        'description': 'راحة القلب في قيام الليل',
        'type': 'قيام',
        'isCompleted': 0,
        'date': today,
        'iconCode': 4,
      },
    ];

    for (final item in items) {
      await db.insert('worships', item);
    }
  }

  // ================= RESET DAILY =================
  Future<void> resetIfNewDay() async {
    final db = await database;

    final today = _today();

    final result = await db.query('worships');

    if (result.isEmpty) {
      await _insertDailyWorships(db);

      return;
    }

    final savedDate = result.first['date'] as String;

    if (savedDate != today) {
      await db.delete('worships');

      await _insertDailyWorships(db);
    }
  }

  // ================= DATE HELPER =================
  String _today() {
    final now = DateTime.now();

    return "${now.year}-${now.month}-${now.day}";
  }
}
