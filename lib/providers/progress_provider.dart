import 'package:flutter/material.dart';
import '../models/progress_entry.dart';
import '../utils/date_utils.dart';

class ProgressProvider extends ChangeNotifier {
  List<ProgressEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<ProgressEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProgressEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Load from database
      _entries = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading progress entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProgressEntry(ProgressEntry entry) async {
    try {
      // TODO: Save to database
      _entries.insert(0, entry);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProgressEntry(ProgressEntry entry) async {
    try {
      // TODO: Update in database
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProgressEntry(String id) async {
    try {
      // TODO: Delete from database
      _entries.removeWhere((e) => e.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<ProgressEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries.where((e) {
      return e.date.isAfter(start) && e.date.isBefore(end);
    }).toList();
  }

  ProgressEntry? getLastEntry() {
    return _entries.isNotEmpty ? _entries.first : null;
  }

  int getDayssinceLastProgress() {
    final lastEntry = getLastEntry();
    if (lastEntry == null) return 0;
    return DateTime.now().difference(lastEntry.date).inDays;
  }

  bool shouldLogProgress() {
    final daysSince = getDayssinceLastProgress();
    return daysSince >= 7; // Log weekly
  }

  List<ProgressEntry> getWeeklyEntries() {
    final now = DateTime.now();
    final weekStart = DateUtil.startOfWeek(now);
    final weekEnd = DateUtil.endOfWeek(now);
    return getEntriesByDateRange(weekStart, weekEnd);
  }

  Map<String, double> getMetricsComparison() {
    final lastEntry = getLastEntry();
    if (lastEntry == null || lastEntry.metrics == null) return {};

    final secondLastEntry = _entries.length > 1 ? _entries[1] : null;
    if (secondLastEntry == null || secondLastEntry.metrics == null) return {};

    final last = lastEntry.metrics!;
    final secondLast = secondLastEntry.metrics!;

    return {
      if (last.weight != null && secondLast.weight != null)
        'weight': (last.weight! - secondLast.weight!).toStringAsFixed(1) as double,
      if (last.chest != null && secondLast.chest != null)
        'chest': (last.chest! - secondLast.chest!).toStringAsFixed(1) as double,
      if (last.waist != null && secondLast.waist != null)
        'waist': (last.waist! - secondLast.waist!).toStringAsFixed(1) as double,
    };
  }
}