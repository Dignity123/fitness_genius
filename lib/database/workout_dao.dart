import 'package:sqflite/sqflite.dart';
import '../models/workout_session.dart';
import '../models/workout_set.dart';
import 'database_helper.dart';

class WorkoutDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Workout Sessions
  Future<void> insertWorkoutSession(WorkoutSession session) async {
    final db = await _dbHelper.database;
    await db.insert('workout_sessions', session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WorkoutSession>> getAllWorkoutSessions() async {
    final db = await _dbHelper.database;
    final result = await db.query('workout_sessions', orderBy: 'startTime DESC');
    return result.map((map) => WorkoutSession.fromMap(map)).toList();
  }

  Future<WorkoutSession?> getWorkoutSessionById(String id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('workout_sessions', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? WorkoutSession.fromMap(result.first) : null;
  }

  Future<List<WorkoutSession>> getCompletedWorkoutSessions() async {
    final db = await _dbHelper.database;
    final result = await db.query('workout_sessions',
        where: 'isCompleted = ?',
        whereArgs: [1],
        orderBy: 'startTime DESC');
    return result.map((map) => WorkoutSession.fromMap(map)).toList();
  }

  Future<List<WorkoutSession>> getWorkoutSessionsByQuestId(String questId) async {
    final db = await _dbHelper.database;
    final result = await db.query('workout_sessions',
        where: 'questId = ?', whereArgs: [questId], orderBy: 'startTime DESC');
    return result.map((map) => WorkoutSession.fromMap(map)).toList();
  }

  Future<void> updateWorkoutSession(WorkoutSession session) async {
    final db = await _dbHelper.database;
    await db.update('workout_sessions', session.toMap(),
        where: 'id = ?', whereArgs: [session.id]);
  }

  Future<void> completeWorkoutSession(String sessionId) async {
    final db = await _dbHelper.database;
    await db.update(
      'workout_sessions',
      {
        'isCompleted': 1,
        'endTime': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<void> deleteWorkoutSession(String id) async {
    final db = await _dbHelper.database;
    await db.delete('workout_sessions', where: 'id = ?', whereArgs: [id]);
    // Also delete exercise logs
    await db.delete('exercise_logs', where: 'sessionId = ?', whereArgs: [id]);
  }

  // Exercise Logs
  Future<void> insertExerciseLog(ExerciseLog log) async {
    final db = await _dbHelper.database;
    await db.insert('exercise_logs', log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ExerciseLog>> getExerciseLogsBySessionId(String sessionId) async {
    final db = await _dbHelper.database;
    final result = await db.query('exercise_logs',
        where: 'sessionId = ?', whereArgs: [sessionId]);
    return result.map((map) => ExerciseLog.fromMap(map)).toList();
  }

  Future<ExerciseLog?> getExerciseLogById(String id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('exercise_logs', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? ExerciseLog.fromMap(result.first) : null;
  }

  Future<void> updateExerciseLog(ExerciseLog log) async {
    final db = await _dbHelper.database;
    await db.update('exercise_logs', log.toMap(),
        where: 'id = ?', whereArgs: [log.id]);
  }

  Future<void> deleteExerciseLog(String id) async {
    final db = await _dbHelper.database;
    await db.delete('exercise_logs', where: 'id = ?', whereArgs: [id]);
    // Also delete workout sets
    await db.delete('workout_sets', where: 'exerciseLogId = ?', whereArgs: [id]);
  }

  // Workout Sets
  Future<void> insertWorkoutSet(WorkoutSet set) async {
    final db = await _dbHelper.database;
    await db.insert('workout_sets', set.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WorkoutSet>> getWorkoutSetsByExerciseLogId(String exerciseLogId) async {
    final db = await _dbHelper.database;
    final result = await db.query('workout_sets',
        where: 'exerciseLogId = ?',
        whereArgs: [exerciseLogId],
        orderBy: 'setNumber ASC');
    return result.map((map) => WorkoutSet.fromMap(map)).toList();
  }

  Future<void> updateWorkoutSet(WorkoutSet set) async {
    final db = await _dbHelper.database;
    await db.update('workout_sets', set.toMap(),
        where: 'id = ?', whereArgs: [set.id]);
  }

  Future<void> deleteWorkoutSet(String id) async {
    final db = await _dbHelper.database;
    await db.delete('workout_sets', where: 'id = ?', whereArgs: [id]);
  }

  // Statistics
  Future<int> getTotalWorkoutSessions() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM workout_sessions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalWorkoutMinutes() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
        'SELECT SUM(totalDuration) as total FROM workout_sessions WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalCaloriesBurned() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
        'SELECT SUM(totalCalories) as total FROM workout_sessions WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}