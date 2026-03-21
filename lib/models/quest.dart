import 'package:uuid/uuid.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final List<String> exerciseIds;
  final int targetReps;
  final int targetSets;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final int xpReward;
  final List<Milestone> milestones;

  Quest({
    String? id,
    required this.title,
    required this.description,
    required this.exerciseIds,
    required this.targetReps,
    required this.targetSets,
    DateTime? createdAt,
    this.completedAt,
    this.isCompleted = false,
    this.xpReward = 100,
    List<Milestone>? milestones,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        milestones = milestones ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'exerciseIds': exerciseIds.join(','),
        'targetReps': targetReps,
        'targetSets': targetSets,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'isCompleted': isCompleted ? 1 : 0,
        'xpReward': xpReward,
      };

  factory Quest.fromMap(Map<String, dynamic> map) => Quest(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        exerciseIds: (map['exerciseIds'] as String).split(','),
        targetReps: map['targetReps'],
        targetSets: map['targetSets'],
        createdAt: DateTime.parse(map['createdAt']),
        completedAt: map['completedAt'] != null
            ? DateTime.parse(map['completedAt'])
            : null,
        isCompleted: map['isCompleted'] == 1,
        xpReward: map['xpReward'],
      );

  Quest copyWith({
    bool? isCompleted,
    DateTime? completedAt,
    int? xpReward,
  }) =>
      Quest(
        id: id,
        title: title,
        description: description,
        exerciseIds: exerciseIds,
        targetReps: targetReps,
        targetSets: targetSets,
        createdAt: createdAt,
        completedAt: completedAt ?? this.completedAt,
        isCompleted: isCompleted ?? this.isCompleted,
        xpReward: xpReward ?? this.xpReward,
        milestones: milestones,
      );
}

class Milestone {
  final String id;
  final String questId;
  final String title;
  final int repsRequired;
  final int setsRequired;
  final bool isCompleted;
  final DateTime? completedAt;
  final Reward? reward;

  Milestone({
    String? id,
    required this.questId,
    required this.title,
    required this.repsRequired,
    required this.setsRequired,
    this.isCompleted = false,
    this.completedAt,
    this.reward,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'questId': questId,
        'title': title,
        'repsRequired': repsRequired,
        'setsRequired': setsRequired,
        'isCompleted': isCompleted ? 1 : 0,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Milestone.fromMap(Map<String, dynamic> map) => Milestone(
        id: map['id'],
        questId: map['questId'],
        title: map['title'],
        repsRequired: map['repsRequired'],
        setsRequired: map['setsRequired'],
        isCompleted: map['isCompleted'] == 1,
        completedAt: map['completedAt'] != null
            ? DateTime.parse(map['completedAt'])
            : null,
      );
}

class Reward {
  final String id;
  final String name;
  final int xpPoints;
  final String? badge;
  final bool isUnlocked;

  Reward({
    String? id,
    required this.name,
    required this.xpPoints,
    this.badge,
    this.isUnlocked = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'xpPoints': xpPoints,
        'badge': badge,
        'isUnlocked': isUnlocked ? 1 : 0,
      };

  factory Reward.fromMap(Map<String, dynamic> map) => Reward(
        id: map['id'],
        name: map['name'],
        xpPoints: map['xpPoints'],
        badge: map['badge'],
        isUnlocked: map['isUnlocked'] == 1,
      );
}