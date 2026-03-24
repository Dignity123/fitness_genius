import 'package:flutter/material.dart';
import '../models/progress_entry.dart';
import '../utils/date_utils.dart';
import '../database/progress_dao.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressDAO _progressDAO = ProgressDAO();

  List<ProgressEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<ProgressEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProgressEntry? get latestEntry =>
      _entries.isNotEmpty ? _entries.first : null;

  BodyMetrics? get latestMetrics => latestEntry?.metrics;

  Future<void> loadProgressEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loadedEntries = await _progressDAO.getAllProgressEntries();
      final hydratedEntries = <ProgressEntry>[];

      for (final entry in loadedEntries) {
        final metric = await _progressDAO.getLatestBodyMetric(entry.id);
        hydratedEntries.add(entry.copyWith(metrics: metric));
      }

      hydratedEntries.sort((a, b) => b.date.compareTo(a.date));
      _entries = hydratedEntries;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading progress entries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> deleteProgressEntry(String id) async {
    try {
      await _progressDAO.deleteProgressEntry(id);
      await loadProgressEntries();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<ProgressEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries.where((e) {
      return !e.date.isBefore(start) && !e.date.isAfter(end);
    }).toList();
  }

  List<ProgressEntry> getWeeklyEntries() {
    final now = DateTime.now();
    final weekStart = DateUtil.startOfWeek(now);
    final weekEnd = DateUtil.endOfWeek(now);

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
      if (l.bodyFatPercentage != null && f.bodyFatPercentage != null)
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
}
