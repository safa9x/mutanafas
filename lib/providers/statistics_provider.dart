import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/worship_provider.dart';
import '../providers/journal_provider.dart';
import '../providers/breathing_provider.dart';
import '../services/statistics_service.dart';

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService();
});

/// ================= WORSHIP STATS =================
final worshipStatsProvider = Provider<_WorshipStats?>((ref) {
  final worshipsAsync = ref.watch(worshipProvider);
  final service = ref.read(statisticsServiceProvider);

  return worshipsAsync.maybeWhen(
    data: (worships) {
      return _WorshipStats(
        completed: service.completed(worships),
        total: service.total(worships),
        progress: service.progress(worships),
      );
    },
    orElse: () => null,
  );
});

/// ================= JOURNAL COUNT =================
final journalCountProvider = Provider<int>((ref) {
  final journalsAsync = ref.watch(journalProvider);

  return journalsAsync.maybeWhen(
    data: (j) => j.length,
    orElse: () => 0,
  );
});

/// ================= BREATHING COUNT =================
final breathingCountProvider = Provider<int>((ref) {
  final breathingAsync = ref.watch(breathingProvider);

  return breathingAsync.maybeWhen(
    data: (b) => b.length,
    orElse: () => 0,
  );
});

/// ================= MODEL =================
class _WorshipStats {
  final int completed;
  final int total;
  final double progress;

  _WorshipStats({
    required this.completed,
    required this.total,
    required this.progress,
  });
}