import '../database/database_helper.dart';
import '../models/worship_model.dart';

class WorshipService {
  final dbHelper = DatabaseHelper.instance;

  /// ================= GET WORSHIPS =================
  Future<List<WorshipItem>> getWorships() async {
    final db = await dbHelper.database;

    final result = await db.query(
      'worships',
      orderBy: 'id ASC',
    );

    return result.map((e) => WorshipItem.fromMap(e)).toList();
  }

  /// ================= TOGGLE WORSHIP =================
  Future<void> toggleWorship(int id, bool value) async {
    final db = await dbHelper.database;

    await db.update(
      'worships',
      {'isCompleted': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ================= RESET DAILY =================
  Future<void> resetDaily() async {
    await dbHelper.resetIfNewDay();
  }
}