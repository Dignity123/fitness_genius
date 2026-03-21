import 'package:uuid/uuid.dart';

class WorkoutSet {
  final String id;
  final String exerciseLogId;
  final int setNumber;
  final int reps;
  final int weight; // in lbs or kg
  final bool isCompleted;
  final String? notes;
  final DateTime timestamp;
  final int? restSeconds;

  WorkoutSet({
    String? id,
    required this.exerciseLogId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.isCompleted = false,
    this.notes,
    DateTime? timestamp,
    this.restSeconds,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'exerciseLogId': exerciseLogId,
        'setNumber': setNumber,
        'reps': reps,
        'weight': weight,
        'isCompleted': isCompleted ? 1 : 0,
        'notes': notes,
        'timestamp': timestamp.toIso8601String(),
        'restSeconds': restSeconds,
      };

  factory WorkoutSet.fromMap(Map<String, dynamic> map) => WorkoutSet(
        id: map['id'],
        exerciseLogId: map['exerciseLogId'],
        setNumber: map['setNumber'],
        reps: map['reps'],
        weight: map['weight'],
        isCompleted: map['isCompleted'] == 1,
        notes: map['notes'],
        timestamp: DateTime.parse(map['timestamp']),
        restSeconds: map['restSeconds'],
      );

  WorkoutSet copyWith({
    int? reps,
    int? weight,
    bool? isCompleted,
    String? notes,
    int? restSeconds,
  }) =>
      WorkoutSet(
        id: id,
        exerciseLogId: exerciseLogId,
        setNumber: setNumber,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        isCompleted: isCompleted ?? this.isCompleted,
        notes: notes ?? this.notes,
        timestamp: timestamp,
        restSeconds: restSeconds ?? this.restSeconds,
      );
}