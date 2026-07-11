import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/worship_model.dart';
import '../services/worship_service.dart';

/// ================= SERVICE PROVIDER =================
final worshipServiceProvider = Provider<WorshipService>((ref) {
  return WorshipService(); 
});

/// ================= DATA PROVIDER =================
final worshipProvider =
    FutureProvider<List<WorshipItem>>((ref) async {

  final service = ref.read(worshipServiceProvider);

  await service.resetDaily(); // 🔥 مهم جدًا

  return service.getWorships();
});

/// ================= ACTIONS =================
final worshipActionsProvider = Provider<WorshipActions>((ref) {
  return WorshipActions(ref);
});

class WorshipActions {
  final Ref ref;

  WorshipActions(this.ref);

  Future<void> toggle(int id, bool value) async {
    final service = ref.read(worshipServiceProvider);

    await service.toggleWorship(id, value);

ref.invalidate(worshipProvider);  }

  Future<void> reset() async {
    final service = ref.read(worshipServiceProvider);

    await service.resetDaily();

ref.invalidate(worshipProvider);  }
}