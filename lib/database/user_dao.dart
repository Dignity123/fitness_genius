// lib/database/user_dao.dart
import 'package:sqflite/sqflite.dart';
import '../models/user_profile.dart';
import 'database_helper.dart';

class UserDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Get the user profile (should only be one)
  Future<UserProfile?> getUserProfile() async {
    final db = await _dbHelper.database;
    final result = await db.query('user_profiles', limit: 1);
    
    if (result.isEmpty) return null;
    return UserProfile.fromMap(result.first);
  }

  // Create default user
  Future<UserProfile> createDefaultUser() async {
    final defaultUser = UserProfile(
      name: 'Fitness Enthusiast',
      email: null,
      totalXP: 0,
      currentLevel: 1,
      currentStreak: 0,
      longestStreak: 0,
      lastWorkoutDate: DateTime.now(),
      unlockedBadges: [],
      preferences: {
        'weightUnit': 'kg',
        'distanceUnit': 'km',
        'notificationsEnabled': true,
        'soundEnabled': true,
        'vibrationEnabled': true,
        'defaultDifficulty': 'intermediate',
        'defaultRestTimer': 60,
      },
    );
    
    await insertUser(defaultUser);
    return defaultUser;
  }

  // Insert user
  Future<void> insertUser(UserProfile user) async {
    final db = await _dbHelper.database;
    await db.insert('user_profiles', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile user) async {
    final db = await _dbHelper.database;
    await db.update('user_profiles', user.toMap(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  // Delete all users (for testing/reset)
  Future<void> deleteAllUsers() async {
    final db = await _dbHelper.database;
    await db.delete('user_profiles');
  }
}