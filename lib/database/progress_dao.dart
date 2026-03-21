import 'package:sqflite/sqflite.dart';
import '../models/progress_entry.dart';
import 'database_helper.dart';

class ProgressDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Progress Entries
  Future<void> insertProgressEntry(ProgressEntry entry) async {
    final db = await _dbHelper.database;
    await db.insert('progress_entries', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProgressEntry>> getAllProgressEntries() async {
    final db = await _dbHelper.database;
    final result = await db.query('progress_entries', orderBy: 'date DESC');
    return result.map((map) => ProgressEntry.fromMap(map)).toList();
  }

  Future<ProgressEntry?> getProgressEntryById(String id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('progress_entries', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? ProgressEntry.fromMap(result.first) : null;
  }

  Future<ProgressEntry?> getLatestProgressEntry() async {
    final db = await _dbHelper.database;
    final result =
        await db.query('progress_entries', orderBy: 'date DESC', limit: 1);
    return result.isNotEmpty ? ProgressEntry.fromMap(result.first) : null;
  }

  Future<List<ProgressEntry>> getProgressEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'progress_entries',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return result.map((map) => ProgressEntry.fromMap(map)).toList();
  }

  Future<void> updateProgressEntry(ProgressEntry entry) async {
    final db = await _dbHelper.database;
    await db.update('progress_entries', entry.toMap(),
        where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteProgressEntry(String id) async {
    final db = await _dbHelper.database;
    await db.delete('progress_entries', where: 'id = ?', whereArgs: [id]);
    // Also delete body metrics
    await db.delete('body_metrics',
        where: 'progressEntryId = ?', whereArgs: [id]);
  }

  // Body Metrics
  Future<void> insertBodyMetric(BodyMetrics metric) async {
    final db = await _dbHelper.database;
    await db.insert('body_metrics', metric.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BodyMetrics>> getBodyMetricsByProgressEntryId(
    String progressEntryId,
  ) async {
    final db = await _dbHelper.database;
    final result = await db.query('body_metrics',
        where: 'progressEntryId = ?',
        whereArgs: [progressEntryId],
        orderBy: 'recordedAt DESC');
    return result.map((map) => BodyMetrics.fromMap(map)).toList();
  }

  Future<BodyMetrics?> getBodyMetricById(String id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('body_metrics', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? BodyMetrics.fromMap(result.first) : null;
  }

  Future<BodyMetrics?> getLatestBodyMetric(String progressEntryId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'body_metrics',
      where: 'progressEntryId = ?',
      whereArgs: [progressEntryId],
      orderBy: 'recordedAt DESC',
      limit: 1,
    );
    return result.isNotEmpty ? BodyMetrics.fromMap(result.first) : null;
  }

  Future<void> updateBodyMetric(BodyMetrics metric) async {
    final db = await _dbHelper.database;
    await db.update('body_metrics', metric.toMap(),
        where: 'id = ?', whereArgs: [metric.id]);
  }

  Future<void> deleteBodyMetric(String id) async {
    final db = await _dbHelper.database;
    await db.delete('body_metrics', where: 'id = ?', whereArgs: [id]);
  }

  // Weight progression
  Future<List<Map<String, dynamic>>> getWeightProgression() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT bm.weight, bm.recordedAt
      FROM body_metrics bm
      WHERE bm.weight IS NOT NULL
      ORDER BY bm.recordedAt ASC
    ''');
    return result;
  }

  // Measurement trends
  Future<List<Map<String, dynamic>>> getMeasurementTrend(
    String measurement,
  ) async {
    final db = await _dbHelper.database;
    final column =
        measurement; // chest, waist, arms, thighs, hips, etc.
    final result = await db.rawQuery('''
      SELECT $column as value, recordedAt
      FROM body_metrics
      WHERE $column IS NOT NULL
      ORDER BY recordedAt ASC
    ''');
    return result;
  }

  // Total progress entries count
  Future<int> getProgressEntriesCount() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM progress_entries');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}