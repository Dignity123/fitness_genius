import 'package:uuid/uuid.dart';

class ProgressEntry {
  final String id;
  final DateTime date;
  final String? photoPath;
  final BodyMetrics? metrics;
  final String? notes;
  final int? totalWorkoutTime; // in minutes
  final int? totalWorkouts;

  ProgressEntry({
    String? id,
    DateTime? date,
    this.photoPath,
    this.metrics,
    this.notes,
    this.totalWorkoutTime,
    this.totalWorkouts,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'photoPath': photoPath,
        'notes': notes,
        'totalWorkoutTime': totalWorkoutTime,
        'totalWorkouts': totalWorkouts,
      };

  factory ProgressEntry.fromMap(Map<String, dynamic> map) => ProgressEntry(
        id: map['id'],
        date: DateTime.parse(map['date']),
        photoPath: map['photoPath'],
        notes: map['notes'],
        totalWorkoutTime: map['totalWorkoutTime'],
        totalWorkouts: map['totalWorkouts'],
      );

  ProgressEntry copyWith({
    String? photoPath,
    BodyMetrics? metrics,
    String? notes,
    int? totalWorkoutTime,
    int? totalWorkouts,
  }) =>
      ProgressEntry(
        id: id,
        date: date,
        photoPath: photoPath ?? this.photoPath,
        metrics: metrics ?? this.metrics,
        notes: notes ?? this.notes,
        totalWorkoutTime: totalWorkoutTime ?? this.totalWorkoutTime,
        totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      );
}

class BodyMetrics {
  final String id;
  final String progressEntryId;
  final double? weight; // lbs or kg
  final double? chest;
  final double? waist;
  final double? hips;
  final double? thighs;
  final double? arms;
  final double? bodyFatPercentage;
  final String? notes;
  final DateTime recordedAt;

  BodyMetrics({
    String? id,
    required this.progressEntryId,
    this.weight,
    this.chest,
    this.waist,
    this.hips,
    this.thighs,
    this.arms,
    this.bodyFatPercentage,
    this.notes,
    DateTime? recordedAt,
  })  : id = id ?? const Uuid().v4(),
        recordedAt = recordedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'progressEntryId': progressEntryId,
        'weight': weight,
        'chest': chest,
        'waist': waist,
        'hips': hips,
        'thighs': thighs,
        'arms': arms,
        'bodyFatPercentage': bodyFatPercentage,
        'notes': notes,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory BodyMetrics.fromMap(Map<String, dynamic> map) => BodyMetrics(
        id: map['id'],
        progressEntryId: map['progressEntryId'],
        weight: map['weight'],
        chest: map['chest'],
        waist: map['waist'],
        hips: map['hips'],
        thighs: map['thighs'],
        arms: map['arms'],
        bodyFatPercentage: map['bodyFatPercentage'],
        notes: map['notes'],
        recordedAt: DateTime.parse(map['recordedAt']),
      );

  BodyMetrics copyWith({
    double? weight,
    double? chest,
    double? waist,
    double? hips,
    double? thighs,
    double? arms,
    double? bodyFatPercentage,
    String? notes,
  }) =>
      BodyMetrics(
        id: id,
        progressEntryId: progressEntryId,
        weight: weight ?? this.weight,
        chest: chest ?? this.chest,
        waist: waist ?? this.waist,
        hips: hips ?? this.hips,
        thighs: thighs ?? this.thighs,
        arms: arms ?? this.arms,
        bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
        notes: notes ?? this.notes,
        recordedAt: recordedAt,
      );
}