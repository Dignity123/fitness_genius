import 'package:sqflite/sqflite.dart';
import '../models/exercise.dart';
import 'database_helper.dart';

class ExerciseDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    await db.insert('exercises', exercise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertExercises(List<Exercise> exercises) async {
    final db = await _dbHelper.database;
    for (var exercise in exercises) {
      await db.insert('exercises', exercise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await _dbHelper.database;
    final result = await db.query('exercises');
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<Exercise?> getExerciseById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('exercises', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Exercise.fromMap(result.first) : null;
  }

  Future<List<Exercise>> getExercisesByCategory(String category) async {
    final db = await _dbHelper.database;
    final result = await db.query('exercises', where: 'category = ?', whereArgs: [category]);
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<List<Exercise>> getExercisesByDifficulty(String difficulty) async {
    final db = await _dbHelper.database;
    final result = await db.query('exercises', where: 'difficulty = ?', whereArgs: [difficulty]);
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<List<Exercise>> searchExercises(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'exercises',
      where: 'name LIKE ? OR description LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<List<Exercise>> getFavoriteExercises() async {
    final db = await _dbHelper.database;
    final result = await db.query('exercises', where: 'isFavorite = ?', whereArgs: [1]);
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    await db.update('exercises', exercise.toMap(), where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<void> toggleFavorite(String exerciseId) async {
    final db = await _dbHelper.database;
    final exercise = await getExerciseById(exerciseId);
    if (exercise != null) {
      await updateExercise(exercise.copyWith(isFavorite: !exercise.isFavorite));
    }
  }

  Future<void> deleteExercise(String id) async {
    final db = await _dbHelper.database;
    await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getExerciseCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM exercises');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Exercise>> getExercisesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final db = await _dbHelper.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    final result = await db.query('exercises', where: 'id IN ($placeholders)', whereArgs: ids);
    return result.map((map) => Exercise.fromMap(map)).toList();
  }
}