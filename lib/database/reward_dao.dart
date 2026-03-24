import 'package:sqflite/sqflite.dart';
import '../models/quest.dart';
import 'database_helper.dart';

class RewardDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertReward(Reward reward) async {
    final db = await _dbHelper.database;
    await db.insert('rewards', reward.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reward>> getAllRewards() async {
    final db = await _dbHelper.database;
    final result = await db.query('rewards', orderBy: 'name ASC');
    return result.map((map) => Reward.fromMap(map)).toList();
  }

  Future<Reward?> getRewardById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('rewards', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Reward.fromMap(result.first) : null;
  }

  Future<List<Reward>> getUnlockedRewards() async {
    final db = await _dbHelper.database;
    final result = await db.query('rewards',
        where: 'isUnlocked = ?', whereArgs: [1], orderBy: 'unlockedAt DESC');
    return result.map((map) => Reward.fromMap(map)).toList();
  }

  Future<void> unlockReward(String rewardId) async {
    final db = await _dbHelper.database;
    await db.update(
      'rewards',
      {
        'isUnlocked': 1,
        'unlockedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [rewardId],
    );
  }

  Future<void> deleteReward(String id) async {
    final db = await _dbHelper.database;
    await db.delete('rewards', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> linkRewardToMilestone(String milestoneId, String rewardId) async {
    final db = await _dbHelper.database;
    await db.insert('milestone_rewards', {
      'milestoneId': milestoneId,
      'rewardId': rewardId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reward>> getRewardsForMilestone(String milestoneId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT r.* FROM rewards r
      INNER JOIN milestone_rewards mr ON r.id = mr.rewardId
      WHERE mr.milestoneId = ?
    ''', [milestoneId]);
    return result.map((map) => Reward.fromMap(map)).toList();
  }

  Future<int> getTotalRewardsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM rewards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getUnlockedRewardsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM rewards WHERE isUnlocked = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}