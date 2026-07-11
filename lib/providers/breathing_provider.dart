import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_helper.dart';
import '../models/breathing_model.dart';

final breathingProvider = StateNotifierProvider<BreathingNotifier,
    AsyncValue<List<BreathingSession>>>(
  (ref) => BreathingNotifier(DatabaseHelper.instance),
);

class BreathingNotifier
    extends StateNotifier<AsyncValue<List<BreathingSession>>> {
  final DatabaseHelper db;

// constructor
  BreathingNotifier(this.db) : super(const AsyncValue.loading()) {
    loadSessions();
  }

  // ================= LOAD =================

  Future<void> loadSessions() async {
    try {
      final database = await db.database;

      final result = await database.query(
        'breathing_sessions',
        orderBy: 'id DESC',
      );
       
      final sessions = result.map((e) => BreathingSession.fromMap(e)).toList();

      state = AsyncValue.data(sessions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }   

  // ================= ADD SESSION =================

  Future<void> addSession({
    required int duration,
    required String moodBefore,
    required String moodAfter,
    required String sessionType,
  }) async {
    try {
      final database = await db.database;

      await database.insert(
        'breathing_sessions',
        {
          'duration': duration,
          'moodBefore': moodBefore,
          'moodAfter': moodAfter,
          'sessionType': sessionType,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      await loadSessions();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
