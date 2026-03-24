import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class MigrationHelper {
  static Future<void> migrateToVersion(Database db, int targetVersion) async {
    final currentVersion = await _getCurrentVersion(db);
    
    for (var version = currentVersion + 1; version <= targetVersion; version++) {
      debugPrint('🔄 Migrating to version $version...');
      await _runMigration(db, version);
    }
  }

  static Future<int> _getCurrentVersion(Database db) async {
    try {
      final result = await db.rawQuery('PRAGMA user_version');
      return result.first['user_version'] as int? ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> _runMigration(Database db, int version) async {
    switch (version) {
      case 2:
        await _migrationToV2(db);
        break;
      case 3:
        await _migrationToV3(db);
        break;
      case 4:
        await _migrationToV4(db);
        break;
      default:
        debugPrint('⚠️ No migration defined for version $version');
    }
    
    await db.execute('PRAGMA user_version = $version');
    debugPrint('✅ Migration to version $version completed');
  }

  static Future<void> _migrationToV2(Database db) async {
    debugPrint('📝 Running migration to version 2...');
    
    // Add password column to user_profiles
    final result = await db.rawQuery("PRAGMA table_info(user_profiles)");
    final hasPasswordColumn = result.any((col) => col['name'] == 'password');
    
    if (!hasPasswordColumn) {
      debugPrint('  Adding password column...');
      await db.execute('ALTER TABLE user_profiles ADD COLUMN password TEXT');
      debugPrint('✅ Password column added');
    } else {
      debugPrint('✅ Password column already exists');
    }
  }

  static Future<void> _migrationToV3(Database db) async {
    debugPrint('📝 Running migration to version 3...');
    
    // Add technique column to exercises
    final exerciseInfo = await db.rawQuery("PRAGMA table_info(exercises)");
    final hasTechnique = exerciseInfo.any((col) => col['name'] == 'technique');
    
    if (!hasTechnique) {
      debugPrint('  Adding technique column to exercises...');
      await db.execute('ALTER TABLE exercises ADD COLUMN technique TEXT');
      debugPrint('✅ Technique column added');
    } else {
      debugPrint('✅ Technique column already exists');
    }
    
    // Add preferences column to user_profiles
    final userInfo = await db.rawQuery("PRAGMA table_info(user_profiles)");
    final hasPreferences = userInfo.any((col) => col['name'] == 'preferences');
    
    if (!hasPreferences) {
      debugPrint('  Adding preferences column to user_profiles...');
      await db.execute('ALTER TABLE user_profiles ADD COLUMN preferences TEXT');
      debugPrint('✅ Preferences column added');
    } else {
      debugPrint('✅ Preferences column already exists');
    }
  }

  static Future<void> _migrationToV4(Database db) async {
    debugPrint('📝 Running migration to version 4...');
    
    // Create rewards table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS rewards (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        xpPoints INTEGER NOT NULL,
        badge TEXT,
        isUnlocked INTEGER DEFAULT 0,
        unlockedAt TEXT
      )
    ''');
    debugPrint('✅ Rewards table created');
    
    // Create milestone_rewards junction table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS milestone_rewards (
        milestoneId TEXT NOT NULL,
        rewardId TEXT NOT NULL,
        FOREIGN KEY (milestoneId) REFERENCES milestones (id),
        FOREIGN KEY (rewardId) REFERENCES rewards (id),
        PRIMARY KEY (milestoneId, rewardId)
      )
    ''');
    debugPrint('✅ Milestone_rewards table created');
    
    // Create index for rewards
    await db.execute('CREATE INDEX IF NOT EXISTS idx_rewards_unlocked ON rewards (isUnlocked)');
    debugPrint('✅ Rewards index created');
  }
}