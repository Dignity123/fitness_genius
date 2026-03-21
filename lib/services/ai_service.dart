import '../models/exercise.dart';
import '../models/user_profile.dart';
import 'package:flutter/foundation.dart';

class AIService {
  static final AIService _instance = AIService._internal();

  factory AIService() {
    return _instance;
  }

  AIService._internal();

  /// Generate workout recommendations based on user data
  Future<List<Map<String, dynamic>>> generateWorkoutRecommendations({
    required UserProfile userProfile,
    required List<Exercise> availableExercises,
    required double intensityLevel,
    required int recoveryScore,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final recommendations = <Map<String, dynamic>>[];

    // Filter exercises by intensity and user level
    final filteredExercises = availableExercises.where((exercise) {
      return _matchesIntensityLevel(exercise, intensityLevel) &&
          _matchesUserLevel(exercise, userProfile.currentLevel);
    }).toList();

    if (filteredExercises.isEmpty) {
      debugPrint('No exercises match current criteria');
      return [];
    }

    // Group by muscle group / category
    final groupedExercises = _groupExercisesByCategory(filteredExercises);

    // Generate 3-5 different workout combinations
    for (int i = 0; i < (groupedExercises.length > 3 ? 3 : groupedExercises.length); i++) {
      final category = groupedExercises.keys.elementAt(i);
      final exercises = groupedExercises[category]!;

      recommendations.add({
        'name': _generateWorkoutName(category, intensityLevel),
        'exercises': exercises.map((e) => e.name).toList(),
        'duration': _calculateWorkoutDuration(exercises.length, intensityLevel),
        'intensity': _getIntensityLabel(intensityLevel),
        'reason': _getRecommendationReason(userProfile, category, recoveryScore),
        'exercises_obj': exercises,
      });
    }

    return recommendations;
  }

  /// Calculate rest days based on intensity and recovery
  Future<int> calculateRestDays({
    required int lastWorkoutDaysAgo,
    required double recoveryScore,
  }) async {
    if (recoveryScore >= 0.8) {
      return 0; // Ready for immediate workout
    } else if (recoveryScore >= 0.6) {
      return 1; // Rest 1 day
    } else if (recoveryScore >= 0.4) {
      return 2; // Rest 2 days
    } else {
      return 3; // Full rest
    }
  }

  /// Assess recovery level based on recent workouts
  Future<double> assessRecoveryLevel({
    required int hoursSinceLastWorkout,
    required int sleepHours,
    required int recentWorkoutCount,
  }) async {
    double recovery = 0.5; // Base recovery

    // Hours since workout (max 48 hours for full recovery)
    if (hoursSinceLastWorkout >= 48) {
      recovery += 0.3;
    } else {
      recovery += (hoursSinceLastWorkout / 48) * 0.3;
    }

    // Sleep quality (7-9 hours optimal)
    if (sleepHours >= 7 && sleepHours <= 9) {
      recovery += 0.2;
    } else if (sleepHours >= 6 && sleepHours <= 10) {
      recovery += 0.1;
    }

    // Recent workout frequency
    if (recentWorkoutCount <= 3) {
      recovery += 0.2;
    } else if (recentWorkoutCount <= 5) {
      recovery += 0.1;
    }

    return (recovery * 100).clamp(0.0, 100.0) / 100;
  }

  // Private helper methods
  bool _matchesIntensityLevel(Exercise exercise, double intensityLevel) {
    if (intensityLevel < 0.33) {
      return exercise.difficulty == 'beginner';
    } else if (intensityLevel < 0.66) {
      return exercise.difficulty == 'intermediate' ||
          exercise.difficulty == 'beginner';
    } else {
      return true; // All difficulties for intense workouts
    }
  }

  bool _matchesUserLevel(Exercise exercise, int userLevel) {
    // User level roughly correlates to difficulty progression
    if (userLevel <= 5) {
      return exercise.difficulty == 'beginner';
    } else if (userLevel <= 15) {
      return exercise.difficulty != 'advanced';
    }
    return true;
  }

  Map<String, List<Exercise>> _groupExercisesByCategory(
    List<Exercise> exercises,
  ) {
    final grouped = <String, List<Exercise>>{};
    for (var exercise in exercises) {
      grouped.putIfAbsent(exercise.category, () => []).add(exercise);
    }
    return grouped;
  }

  String _generateWorkoutName(String category, double intensity) {
    final intensityLabel = _getIntensityLabel(intensity);
    final categoryLabel = category.replaceAll('_', ' ').toTitleCase();
    return '$intensityLabel $categoryLabel Workout';
  }

  int _calculateWorkoutDuration(int exerciseCount, double intensity) {
    const baseMinutes = 5; // Base time per exercise
    final minutes = (exerciseCount * baseMinutes * (1 + intensity)).toInt();
    return minutes.clamp(20, 120);
  }

  String _getIntensityLabel(double intensity) {
    if (intensity < 0.33) return 'Light';
    if (intensity < 0.66) return 'Moderate';
    return 'Intense';
  }

  String _getRecommendationReason(
    UserProfile profile,
    String category,
    int recoveryScore,
  ) {
    final reasons = [
      'Optimized for your current recovery level',
      'Based on your fitness goals and progress',
      'Targets areas you need improvement on',
      'Builds on your recent workout history',
      'Balanced to prevent overtraining',
      'Matches your current energy level',
    ];
    return reasons[profile.totalXP % reasons.length];
  }
}

extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}