import '../database/database_helper.dart';
import '../models/journal_model.dart';

class JournalService {
  final dbHelper = DatabaseHelper.instance;

  /// ================= GET ALL JOURNALS =================
  Future<List<Journal>> getAll() async {
    final db = await dbHelper.database;

    final result = await db.query(
      'journals',
      orderBy: 'id DESC',
    );

    return result.map((e) => Journal.fromMap(e)).toList();
  }

  /// ================= ADD JOURNAL =================
  Future<void> add(String content) async {
    final db = await dbHelper.database;

    await db.insert(
      'journals',
      {
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  /// ================= UPDATE JOURNAL =================
  Future<void> update(int id, String content) async {
    final db = await dbHelper.database;

    await db.update(
      'journals',
      {
        'content': content,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ================= DELETE JOURNAL =================
  Future<void> delete(int id) async {
    final db = await dbHelper.database;

    await db.delete(
      'journals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}