import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? password;
  final String? profileImagePath;
  final int totalXP;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastWorkoutDate;
  final DateTime createdAt;
  final List<String> unlockedBadges;
  final Map<String, dynamic> preferences;

  UserProfile({
    String? id,
    required this.name,
    this.email,
    this.password,
    this.profileImagePath,
    this.totalXP = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    DateTime? lastWorkoutDate,
    DateTime? createdAt,
    List<String>? unlockedBadges,
    Map<String, dynamic>? preferences,
  })  : id = id ?? const Uuid().v4(),
        lastWorkoutDate = lastWorkoutDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        unlockedBadges = unlockedBadges ?? [],
        preferences = preferences ?? {};

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'profileImagePath': profileImagePath,
        'totalXP': totalXP,
        'currentLevel': currentLevel,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastWorkoutDate': lastWorkoutDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'unlockedBadges': unlockedBadges.join(','),
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        profileImagePath: map['profileImagePath'],
        totalXP: map['totalXP'],
        currentLevel: map['currentLevel'],
        currentStreak: map['currentStreak'],
        longestStreak: map['longestStreak'],
        lastWorkoutDate: DateTime.parse(map['lastWorkoutDate']),
        createdAt: DateTime.parse(map['createdAt']),
        unlockedBadges: (map['unlockedBadges'] as String?)
                ?.split(',')
                .where((b) => b.isNotEmpty)
                .toList() ??
            [],
      );

  UserProfile copyWith({
    int? totalXP,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
    List<String>? unlockedBadges,
    String? profileImagePath,
    String? password,
  }) =>
      UserProfile(
        id: id,
        name: name,
        email: email,
        password: password ?? this.password,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        totalXP: totalXP ?? this.totalXP,
        currentLevel: currentLevel ?? this.currentLevel,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
        createdAt: createdAt,
        unlockedBadges: unlockedBadges ?? this.unlockedBadges,
        preferences: preferences,
      );

  int getNextLevelXP() => currentLevel * 1000;
  double getLevelProgress() => (totalXP % 1000) / 1000;
}