import 'package:sqflite/sqflite.dart';
import '../models/user_profile.dart';
import 'database_helper.dart';

class UserDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertUserProfile(UserProfile profile) async {
    final db = await _dbHelper.database;
    await db.insert('user_profiles', profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final db = await _dbHelper.database;
    final result =
        await db.query('user_profiles', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? UserProfile.fromMap(result.first) : null;
  }

  Future<UserProfile?> getFirstUserProfile() async {
    final db = await _dbHelper.database;
    final result = await db.query('user_profiles', limit: 1);
    return result.isNotEmpty ? UserProfile.fromMap(result.first) : null;
  }

  Future<List<UserProfile>> getAllUserProfiles() async {
    final db = await _dbHelper.database;
    final result = await db.query('user_profiles');
    return result.map((map) => UserProfile.fromMap(map)).toList();
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await _dbHelper.database;
    await db.update('user_profiles', profile.toMap(),
        where: 'id = ?', whereArgs: [profile.id]);
  }

  Future<void> updateUserXP(String userId, int newXP) async {
    final db = await _dbHelper.database;
    final newLevel = (newXP ~/ 1000) + 1;
    await db.update(
      'user_profiles',
      {
        'totalXP': newXP,
        'currentLevel': newLevel,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateUserStreak(
    String userId,
    int currentStreak,
    int longestStreak,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'user_profiles',
      {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastWorkoutDate': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> unlockBadge(String userId, String badge) async {
    final db = await _dbHelper.database;
    final profile = await getUserProfile(userId);
    if (profile != null) {
      if (!profile.unlockedBadges.contains(badge)) {
        final updatedBadges = [...profile.unlockedBadges, badge];
        await db.update(
          'user_profiles',
          {
            'unlockedBadges': updatedBadges.join(','),
          },
          where: 'id = ?',
          whereArgs: [userId],
        );
      }
    }
  }

  Future<void> deleteUserProfile(String id) async {
    final db = await _dbHelper.database;
    await db.delete('user_profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalUsers() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM user_profiles');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalXPAcrossAllUsers() async {
    final db = await _dbHelper.database;
    final result = await db
        .rawQuery('SELECT SUM(totalXP) as total FROM user_profiles');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}