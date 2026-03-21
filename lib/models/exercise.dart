import 'package:uuid/uuid.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final String category; // 'cardio', 'strength', 'flexibility', 'balance'
  final String? equipment;
  final List<String> muscleGroups;
  final String? videoUrl;
  final String? imageUrl;
  final int? sets;
  final int? reps;
  final DateTime createdAt;
  final bool isFavorite;

  Exercise({
    String? id,
    required this.name,
    required this.description,
    List<String>? tags,
    this.difficulty = 'intermediate',
    this.category = 'strength',
    this.equipment,
    List<String>? muscleGroups,
    this.videoUrl,
    this.imageUrl,
    this.sets = 3,
    this.reps = 10,
    DateTime? createdAt,
    this.isFavorite = false,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? [],
        muscleGroups = muscleGroups ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'tags': tags.join(','),
        'difficulty': difficulty,
        'category': category,
        'equipment': equipment,
        'muscleGroups': muscleGroups.join(','),
        'videoUrl': videoUrl,
        'imageUrl': imageUrl,
        'sets': sets,
        'reps': reps,
        'createdAt': createdAt.toIso8601String(),
        'isFavorite': isFavorite ? 1 : 0,
      };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        tags: (map['tags'] as String).split(',').where((t) => t.isNotEmpty).toList(),
        difficulty: map['difficulty'],
        category: map['category'],
        equipment: map['equipment'],
        muscleGroups: (map['muscleGroups'] as String).split(',').where((m) => m.isNotEmpty).toList(),
        videoUrl: map['videoUrl'],
        imageUrl: map['imageUrl'],
        sets: map['sets'],
        reps: map['reps'],
        createdAt: DateTime.parse(map['createdAt']),
        isFavorite: map['isFavorite'] == 1,
      );

  Exercise copyWith({
    bool? isFavorite,
    int? sets,
    int? reps,
  }) =>
      Exercise(
        id: id,
        name: name,
        description: description,
        tags: tags,
        difficulty: difficulty,
        category: category,
        equipment: equipment,
        muscleGroups: muscleGroups,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
        createdAt: createdAt,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}