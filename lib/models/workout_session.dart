import 'package:uuid/uuid.dart';
import 'workout_set.dart';

class WorkoutSession {
  final String id;
  final String questId;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ExerciseLog> exerciseLogs;
  final bool isCompleted;
  final int totalCalories;
  final int totalDuration; // in minutes
  final String? notes;

  WorkoutSession({
    String? id,
    required this.questId,
    required this.name,
    DateTime? startTime,
    this.endTime,
    List<ExerciseLog>? exerciseLogs,
    this.isCompleted = false,
    this.totalCalories = 0,
    this.totalDuration = 0,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        startTime = startTime ?? DateTime.now(),
        exerciseLogs = exerciseLogs ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'questId': questId,
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
        'totalCalories': totalCalories,
        'totalDuration': totalDuration,
        'notes': notes,
      };

  factory WorkoutSession.fromMap(Map<String, dynamic> map) => WorkoutSession(
        id: map['id'],
        questId: map['questId'],
        name: map['name'],
        startTime: DateTime.parse(map['startTime']),
        endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
        isCompleted: map['isCompleted'] == 1,
        totalCalories: map['totalCalories'],
        totalDuration: map['totalDuration'],
        notes: map['notes'],
      );

  WorkoutSession copyWith({
    DateTime? endTime,
    bool? isCompleted,
    List<ExerciseLog>? exerciseLogs,
    int? totalCalories,
    int? totalDuration,
    String? notes,
  }) =>
      WorkoutSession(
        id: id,
        questId: questId,
        name: name,
        startTime: startTime,
        endTime: endTime ?? this.endTime,
        exerciseLogs: exerciseLogs ?? this.exerciseLogs,
        isCompleted: isCompleted ?? this.isCompleted,
        totalCalories: totalCalories ?? this.totalCalories,
        totalDuration: totalDuration ?? this.totalDuration,
        notes: notes ?? this.notes,
      );

  int getDuration() {
    final duration = (endTime ?? DateTime.now()).difference(startTime);
    return duration.inMinutes;
  }
}

class ExerciseLog {
  final String id;
  final String sessionId;
  final String exerciseId;
  final String exerciseName;
  final List<WorkoutSet> sets;
  final int totalReps;
  final int totalWeight;
  final String? notes;

  ExerciseLog({
    String? id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseName,
    List<WorkoutSet>? sets,
    this.totalReps = 0,
    this.totalWeight = 0,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        sets = sets ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'sessionId': sessionId,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'totalReps': totalReps,
        'totalWeight': totalWeight,
        'notes': notes,
      };

  factory ExerciseLog.fromMap(Map<String, dynamic> map) => ExerciseLog(
        id: map['id'],
        sessionId: map['sessionId'],
        exerciseId: map['exerciseId'],
        exerciseName: map['exerciseName'],
        totalReps: map['totalReps'],
        totalWeight: map['totalWeight'],
        notes: map['notes'],
      );

  ExerciseLog copyWith({
    List<WorkoutSet>? sets,
    int? totalReps,
    int? totalWeight,
    String? notes,
  }) =>
      ExerciseLog(
        id: id,
        sessionId: sessionId,
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        sets: sets ?? this.sets,
        totalReps: totalReps ?? this.totalReps,
        totalWeight: totalWeight ?? this.totalWeight,
        notes: notes ?? this.notes,
      );
}