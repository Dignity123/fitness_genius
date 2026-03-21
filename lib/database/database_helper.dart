import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_genius.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // User Profile
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        profileImagePath TEXT,
        totalXP INTEGER DEFAULT 0,
        currentLevel INTEGER DEFAULT 1,
        currentStreak INTEGER DEFAULT 0,
        longestStreak INTEGER DEFAULT 0,
        lastWorkoutDate TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        unlockedBadges TEXT
      )
    ''');

    // Quests
    await db.execute('''
      CREATE TABLE quests (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        exerciseIds TEXT NOT NULL,
        targetReps INTEGER NOT NULL,
        targetSets INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        completedAt TEXT,
        isCompleted INTEGER DEFAULT 0,
        xpReward INTEGER DEFAULT 100
      )
    ''');

    // Milestones
    await db.execute('''
      CREATE TABLE milestones (
        id TEXT PRIMARY KEY,
        questId TEXT NOT NULL,
        title TEXT NOT NULL,
        repsRequired INTEGER NOT NULL,
        setsRequired INTEGER NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        completedAt TEXT,
        FOREIGN KEY (questId) REFERENCES quests (id)
      )
    ''');

    // Exercises
    await db.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        tags TEXT,
        difficulty TEXT DEFAULT 'intermediate',
        category TEXT DEFAULT 'strength',
        equipment TEXT,
        muscleGroups TEXT,
        videoUrl TEXT,
        imageUrl TEXT,
        sets INTEGER DEFAULT 3,
        reps INTEGER DEFAULT 10,
        createdAt TEXT NOT NULL,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    // Workout Sessions
    await db.execute('''
      CREATE TABLE workout_sessions (
        id TEXT PRIMARY KEY,
        questId TEXT NOT NULL,
        name TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT,
        isCompleted INTEGER DEFAULT 0,
        totalCalories INTEGER DEFAULT 0,
        totalDuration INTEGER DEFAULT 0,
        notes TEXT,
        FOREIGN KEY (questId) REFERENCES quests (id)
      )
    ''');

    // Exercise Logs
    await db.execute('''
      CREATE TABLE exercise_logs (
        id TEXT PRIMARY KEY,
        sessionId TEXT NOT NULL,
        exerciseId TEXT NOT NULL,
        exerciseName TEXT NOT NULL,
        totalReps INTEGER DEFAULT 0,
        totalWeight INTEGER DEFAULT 0,
        notes TEXT,
        FOREIGN KEY (sessionId) REFERENCES workout_sessions (id),
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      )
    ''');

    // Workout Sets
    await db.execute('''
      CREATE TABLE workout_sets (
        id TEXT PRIMARY KEY,
        exerciseLogId TEXT NOT NULL,
        setNumber INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight INTEGER NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        notes TEXT,
        timestamp TEXT NOT NULL,
        restSeconds INTEGER,
        FOREIGN KEY (exerciseLogId) REFERENCES exercise_logs (id)
      )
    ''');

    // Progress Entries
    await db.execute('''
      CREATE TABLE progress_entries (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        photoPath TEXT,
        notes TEXT,
        totalWorkoutTime INTEGER,
        totalWorkouts INTEGER
      )
    ''');

    // Body Metrics
    await db.execute('''
      CREATE TABLE body_metrics (
        id TEXT PRIMARY KEY,
        progressEntryId TEXT NOT NULL,
        weight REAL,
        chest REAL,
        waist REAL,
        hips REAL,
        thighs REAL,
        arms REAL,
        bodyFatPercentage REAL,
        notes TEXT,
        recordedAt TEXT NOT NULL,
        FOREIGN KEY (progressEntryId) REFERENCES progress_entries (id)
      )
    ''');

    // Create indices for performance
    await db.execute('CREATE INDEX idx_quests_createdAt ON quests (createdAt)');
    await db.execute('CREATE INDEX idx_sessions_questId ON workout_sessions (questId)');
    await db.execute('CREATE INDEX idx_exercises_category ON exercises (category)');
    await db.execute('CREATE INDEX idx_progress_date ON progress_entries (date)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }

  Future<void> close() async {
    _database?.close();
    _database = null;
  }
}