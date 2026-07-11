import '../models/worship_model.dart';

class StatisticsService {

  int completed(List<WorshipItem> items) {
    return items.where((e) => e.isCompleted).length;
  }

  int total(List<WorshipItem> items) {
    return items.length;
  }

  double progress(List<WorshipItem> items) {
    if (items.isEmpty) return 0;
    return completed(items) / items.length;
  }
}