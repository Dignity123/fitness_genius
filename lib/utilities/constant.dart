class AppConstants {
  // Database
  static const String dbName = 'fitness_genius.db';
  static const int dbVersion = 1;

  // Table names
  static const String tableUserProfiles = 'user_profiles';
  static const String tableQuests = 'quests';
  static const String tableMilestones = 'milestones';
  static const String tableExercises = 'exercises';
  static const String tableWorkoutSessions = 'workout_sessions';
  static const String tableExerciseLogs = 'exercise_logs';
  static const String tableWorkoutSets = 'workout_sets';
  static const String tableProgressEntries = 'progress_entries';
  static const String tableBodyMetrics = 'body_metrics';

  // Preferences keys
  static const String prefUserId = 'user_id';
  static const String prefUsername = 'username';
  static const String prefLastWorkoutDate = 'last_workout_date';

  // Categories
  static const List<String> exerciseCategories = [
    'cardio',
    'strength',
    'flexibility',
    'balance',
  ];

  static const List<String> difficultyLevels = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  // Streak calculation
  static const int streakResetDays = 2;

  // XP calculations
  static const int xpPerCompletedSet = 10;
  static const int xpPerMilestone = 100;
  static const int xpPerQuestCompletion = 500;

  // Level thresholds
  static const int xpPerLevel = 1000;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Animation durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // Strings
  static const String appName = 'Fitness Genius';
  static const String appVersion = '1.0.0';

  // Error messages
  static const String errorEmptyField = 'This field cannot be empty';
  static const String errorInvalidInput = 'Invalid input';
  static const String errorDatabaseError = 'Database error occurred';
  static const String errorLoadingData = 'Error loading data';

  // Success messages
  static const String successQuestCreated = 'Quest created successfully';
  static const String successQuestCompleted = 'Quest completed! You earned XP';
  static const String successWorkoutLogged = 'Workout logged successfully';
}