import 'package:sqflite/sqflite.dart';
import '../models/quest.dart';
import 'database_helper.dart';

class QuestDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertQuest(Quest quest) async {
    final db = await _dbHelper.database;
    await db.insert('quests', quest.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Quest>> getAllQuests() async {
    final db = await _dbHelper.database;
    final result = await db.query('quests', orderBy: 'createdAt DESC');
    return result.map((map) => Quest.fromMap(map)).toList();
  }

  Future<Quest?> getQuestById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('quests', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Quest.fromMap(result.first) : null;
  }

  Future<List<Quest>> getActiveQuests() async {
    final db = await _dbHelper.database;
    final result = await db.query('quests', where: 'isCompleted = ?', whereArgs: [0]);
    return result.map((map) => Quest.fromMap(map)).toList();
  }

  Future<List<Quest>> getCompletedQuests() async {
    final db = await _dbHelper.database;
    final result = await db.query('quests', where: 'isCompleted = ?', whereArgs: [1]);
    return result.map((map) => Quest.fromMap(map)).toList();
  }

  Future<void> updateQuest(Quest quest) async {
    final db = await _dbHelper.database;
    await db.update('quests', quest.toMap(), where: 'id = ?', whereArgs: [quest.id]);
  }

  Future<void> completeQuest(String questId) async {
    final db = await _dbHelper.database;
    await db.update(
      'quests',
      {'isCompleted': 1, 'completedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [questId],
    );
  }

  Future<void> deleteQuest(String questId) async {
    final db = await _dbHelper.database;
    await db.delete('quests', where: 'id = ?', whereArgs: [questId]);
    await db.delete('milestones', where: 'questId = ?', whereArgs: [questId]);
  }

  // Milestone operations
  Future<void> insertMilestone(Milestone milestone) async {
    final db = await _dbHelper.database;
    await db.insert('milestones', milestone.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Milestone>> getMilestonesByQuestId(String questId) async {
    final db = await _dbHelper.database;
    final result = await db.query('milestones', where: 'questId = ?', whereArgs: [questId]);
    return result.map((map) => Milestone.fromMap(map)).toList();
  }

  Future<void> completeMilestone(String milestoneId) async {
    final db = await _dbHelper.database;
    await db.update(
      'milestones',
      {'isCompleted': 1, 'completedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [milestoneId],
    );
  }

  Future<void> updateMilestone(Milestone milestone) async {
    final db = await _dbHelper.database;
    await db.update('milestones', milestone.toMap(), where: 'id = ?', whereArgs: [milestone.id]);
  }

  Future<void> deleteMilestone(String milestoneId) async {
    final db = await _dbHelper.database;
    await db.delete('milestones', where: 'id = ?', whereArgs: [milestoneId]);
  }

  Future<int> getTotalQuestCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM quests');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getCompletedQuestCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM quests WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalXPEarned() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT SUM(xpReward) as total FROM quests WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}