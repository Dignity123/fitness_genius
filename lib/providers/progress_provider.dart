import 'package:flutter/material.dart';
import '../models/progress_entry.dart';
import '../utils/date_utils.dart';
<<<<<<< HEAD

class ProgressProvider extends ChangeNotifier {
=======
import '../database/progress_dao.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressDAO _progressDAO = ProgressDAO();

>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
  List<ProgressEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<ProgressEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

<<<<<<< HEAD
=======
  ProgressEntry? get latestEntry =>
      _entries.isNotEmpty ? _entries.first : null;

  BodyMetrics? get latestMetrics => latestEntry?.metrics;

  /// ===============================
  /// LOAD DATA
  /// ===============================
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
  Future<void> loadProgressEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
<<<<<<< HEAD
      // TODO: Load from database
      _entries = [];
      _error = null;
=======
      final loadedEntries = await _progressDAO.getAllProgressEntries();
      final hydratedEntries = <ProgressEntry>[];

      for (final entry in loadedEntries) {
        final metric = await _progressDAO.getLatestBodyMetric(entry.id);
        hydratedEntries.add(entry.copyWith(metrics: metric));
      }

      hydratedEntries.sort((a, b) => b.date.compareTo(a.date));
      _entries = hydratedEntries;
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading progress entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

<<<<<<< HEAD
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
=======
  /// ===============================
  /// ===============================
  Future<void> saveBodyMeasurements({
    required DateTime selectedDate,
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? thighs,
    double? arms,
    double? bodyFatPercentage,
    String? notes,
  }) async {
    try {
      ProgressEntry? existingEntry;

      for (final entry in _entries) {
        final sameDay = entry.date.year == selectedDate.year &&
            entry.date.month == selectedDate.month &&
            entry.date.day == selectedDate.day;

        if (sameDay) {
          existingEntry = entry;
          break;
        }
      }

      if (existingEntry == null) {
        final newEntryId = selectedDate.millisecondsSinceEpoch.toString();

        final newEntry = ProgressEntry(
          id: newEntryId,
          date: selectedDate,
          notes: notes,
        );

        final newMetric = BodyMetrics(
          progressEntryId: newEntryId,
          weight: weight,
          chest: chest,
          waist: waist,
          hips: hips,
          thighs: thighs,
          arms: arms,
          bodyFatPercentage: bodyFatPercentage,
          notes: notes,
          recordedAt: selectedDate,
        );

        await _progressDAO.insertProgressEntry(newEntry);
        await _progressDAO.insertBodyMetric(newMetric);
      } else {
        final existingMetric =
            await _progressDAO.getLatestBodyMetric(existingEntry.id);

        final updatedEntry = existingEntry.copyWith(
          notes: notes ?? existingEntry.notes,
        );
        await _progressDAO.updateProgressEntry(updatedEntry);

        if (existingMetric == null) {
          final newMetric = BodyMetrics(
            progressEntryId: existingEntry.id,
            weight: weight,
            chest: chest,
            waist: waist,
            hips: hips,
            thighs: thighs,
            arms: arms,
            bodyFatPercentage: bodyFatPercentage,
            notes: notes,
            recordedAt: selectedDate,
          );
          await _progressDAO.insertBodyMetric(newMetric);
        } else {
          final updatedMetric = BodyMetrics(
            id: existingMetric.id,
            progressEntryId: existingEntry.id,
            weight: weight ?? existingMetric.weight,
            chest: chest ?? existingMetric.chest,
            waist: waist ?? existingMetric.waist,
            hips: hips ?? existingMetric.hips,
            thighs: thighs ?? existingMetric.thighs,
            arms: arms ?? existingMetric.arms,
            bodyFatPercentage:
                bodyFatPercentage ?? existingMetric.bodyFatPercentage,
            notes: (notes != null && notes.trim().isNotEmpty)
                ? notes
                : existingMetric.notes,
            recordedAt: selectedDate,
          );

          await _progressDAO.updateBodyMetric(updatedMetric);
        }
      }

      await loadProgressEntries();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error saving body measurements: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// ===============================
  /// DELETE
  /// ===============================
  Future<void> deleteProgressEntry(String id) async {
    try {
      await _progressDAO.deleteProgressEntry(id);
      await loadProgressEntries();
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

<<<<<<< HEAD
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

=======
  /// ===============================
  /// RANGE QUERY
  /// ===============================
  List<ProgressEntry> getEntriesByDateRange(
      DateTime start, DateTime end) {
    return _entries.where((e) {
      return !e.date.isBefore(start) && !e.date.isAfter(end);
    }).toList();
  }

  /// ===============================
  /// WEEKLY LOGIC
  /// ===============================
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
  List<ProgressEntry> getWeeklyEntries() {
    final now = DateTime.now();
    final weekStart = DateUtil.startOfWeek(now);
    final weekEnd = DateUtil.endOfWeek(now);
<<<<<<< HEAD
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
=======

    final weekly = getEntriesByDateRange(weekStart, weekEnd);
    weekly.sort((a, b) => a.date.compareTo(b.date));
    return weekly;
  }

  List<ProgressEntry> getLast7DaysEntries() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));

    final results = _entries.where((entry) {
      final d = entry.date;
      return !d.isBefore(start) && !d.isAfter(now);
    }).toList();

    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  ProgressEntry? getWeeklyFirstEntry() {
    final weekly = getWeeklyEntries();
    if (weekly.isEmpty) return null;
    return weekly.first;
  }

  ProgressEntry? getWeeklyLatestEntry() {
    final weekly = getWeeklyEntries();
    if (weekly.isEmpty) return null;
    return weekly.last;
  }

  /// ===============================
  /// WEEKLY COMPARISON
  /// ===============================
  Map<String, double> getWeeklyComparison() {
    final first = getWeeklyFirstEntry();
    final latest = getWeeklyLatestEntry();

    if (first == null ||
        latest == null ||
        first.metrics == null ||
        latest.metrics == null) {
      return {};
    }

    final f = first.metrics!;
    final l = latest.metrics!;

    return {
      if (l.weight != null && f.weight != null)
        'weight': l.weight! - f.weight!,
      if (l.bodyFatPercentage != null &&
          f.bodyFatPercentage != null)
        'bodyFat': l.bodyFatPercentage! - f.bodyFatPercentage!,
      if (l.chest != null && f.chest != null)
        'chest': l.chest! - f.chest!,
      if (l.waist != null && f.waist != null)
        'waist': l.waist! - f.waist!,
      if (l.hips != null && f.hips != null)
        'hips': l.hips! - f.hips!,
      if (l.thighs != null && f.thighs != null)
        'thighs': l.thighs! - f.thighs!,
      if (l.arms != null && f.arms != null)
        'arms': l.arms! - f.arms!,
    };
  }

  /// ===============================
  /// WEEKLY SUMMARY（UI）
  /// ===============================
  Map<String, String> getWeeklySummary() {
    final weeklyEntries = getWeeklyEntries();
    final comparison = getWeeklyComparison();

    return {
      'entries': '${weeklyEntries.length}',
      'weight': _formatChange(comparison['weight'], 'kg'),
      'bodyFat': _formatChange(comparison['bodyFat'], '%'),
      'chest': _formatChange(comparison['chest'], 'cm'),
      'waist': _formatChange(comparison['waist'], 'cm'),
      'hips': _formatChange(comparison['hips'], 'cm'),
      'thighs': _formatChange(comparison['thighs'], 'cm'),
      'arms': _formatChange(comparison['arms'], 'cm'),
    };
  }

  String _formatChange(double? value, String unit) {
    if (value == null) return '--';
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)} $unit';
  }
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
}