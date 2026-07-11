import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/journal_model.dart';
 
class JournalNotifier extends StateNotifier<AsyncValue<List<Journal>>> {
  final DatabaseHelper db;   

  JournalNotifier(this.db) : super(const AsyncValue.loading()) {
    loadJournals();
  }

  // ================= LOAD =================
  Future<void> loadJournals() async {
    try {
      final database = await db.database;

      final result = await database.query(
        'journals',
        orderBy: 'id DESC',
      );

      final data =
          result.map((e) => Journal.fromMap(e)).toList();

      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ================= ADD =================
  Future<void> addJournal(String content) async {
    final database = await db.database;

    await database.insert('journals', {
      'content': content,
      'createdAt': DateTime.now().toString().substring(0, 16),
    });

    await loadJournals();
  }

  // ================= UPDATE =================
  Future<void> updateJournal(Journal journal) async {
    final database = await db.database;

    await database.update(
      'journals',
      journal.toMap(),
      where: 'id = ?',
      whereArgs: [journal.id],
    );

    await loadJournals();
  }

  // ================= DELETE =================
  Future<void> deleteJournal(int id) async {
    final database = await db.database;

    await database.delete(
      'journals',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadJournals();
  }
}

// ================= PROVIDER =================
final journalProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<Journal>>>(
  (ref) => JournalNotifier(DatabaseHelper.instance),
);