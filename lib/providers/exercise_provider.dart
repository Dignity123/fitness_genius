import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../database/exercise_dao.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseDAO _exerciseDAO = ExerciseDAO();

  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';
  String _selectedDifficulty = '';
  String _searchQuery = '';

  List<Exercise> get exercises => _exercises;
  List<Exercise> get filteredExercises => _filteredExercises;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;
  String get searchQuery => _searchQuery;

  Future<void> loadExercises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exercises = await _exerciseDAO.getAllExercises();

      if (_exercises.isEmpty) {
        final defaults = _defaultExercises();
        await _exerciseDAO.insertExercises(defaults);
        _exercises = await _exerciseDAO.getAllExercises();
      }

      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading exercises: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExercise(Exercise exercise) async {
    try {
      await _exerciseDAO.insertExercise(exercise);
      _exercises.add(exercise);
      _applyFilters();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _exerciseDAO.updateExercise(exercise);
      final index = _exercises.indexWhere((e) => e.id == exercise.id);
      if (index != -1) {
        _exercises[index] = exercise;
        _applyFilters();
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _exerciseDAO.deleteExercise(id);
      _exercises.removeWhere((e) => e.id == id);
      _applyFilters();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String exerciseId) async {
    try {
      await _exerciseDAO.toggleFavorite(exerciseId);
      final index = _exercises.indexWhere((e) => e.id == exerciseId);
      if (index != -1) {
        _exercises[index] = _exercises[index].copyWith(
          isFavorite: !_exercises[index].isFavorite,
        );
        _applyFilters();
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category == 'All' ? '' : category;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedDifficulty(String difficulty) {
    _selectedDifficulty = difficulty == 'All' ? '' : difficulty;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredExercises = _exercises.where((exercise) {
      final categoryMatch = _selectedCategory.isEmpty ||
          exercise.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          exercise.tags.any(
            (tag) => tag.toLowerCase() == _selectedCategory.toLowerCase(),
          );

      final difficultyMatch = _selectedDifficulty.isEmpty ||
          exercise.difficulty.toLowerCase() ==
              _selectedDifficulty.toLowerCase();

      final searchMatch = _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      return categoryMatch && difficultyMatch && searchMatch;
    }).toList();
  }

  List<Exercise> getFavoriteExercises() {
    return _exercises.where((e) => e.isFavorite).toList();
  }

  Future<Exercise?> getExerciseById(String id) async {
    try {
      return await _exerciseDAO.getExerciseById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  List<Exercise> _defaultExercises() {
    return [
      Exercise(
        name: 'Push Up',
        description: 'Classic upper body exercise for chest, shoulders, and triceps.',
        tags: ['Strength', 'Chest', 'Bodyweight'],
        difficulty: 'beginner',
        category: 'strength',
        muscleGroups: ['chest', 'shoulders', 'triceps'],
        sets: 3,
        reps: 12,
      ),
      Exercise(
        name: 'Squat',
        description: 'Lower body exercise that targets quads, glutes, and hamstrings.',
        tags: ['Strength', 'Legs'],
        difficulty: 'beginner',
        category: 'strength',
        muscleGroups: ['quads', 'glutes', 'hamstrings'],
        sets: 3,
        reps: 15,
      ),
      Exercise(
        name: 'Jumping Jacks',
        description: 'Simple cardio warm-up that raises heart rate fast.',
        tags: ['Cardio', 'Warmup'],
        difficulty: 'beginner',
        category: 'cardio',
        muscleGroups: ['full body'],
        sets: 3,
        reps: 30,
      ),
      Exercise(
        name: 'Plank',
        description: 'Core stability movement for abs and lower back.',
        tags: ['Core', 'Strength'],
        difficulty: 'intermediate',
        category: 'strength',
        muscleGroups: ['abs', 'core', 'lower back'],
        sets: 3,
        reps: 1,
      ),
      Exercise(
        name: 'Lunges',
        description: 'Single-leg lower body exercise for balance and strength.',
        tags: ['Strength', 'Legs', 'Balance'],
        difficulty: 'intermediate',
        category: 'balance',
        muscleGroups: ['quads', 'glutes', 'hamstrings'],
        sets: 3,
        reps: 10,
      ),
      Exercise(
        name: 'Hamstring Stretch',
        description: 'Improves flexibility in the hamstrings and lower back.',
        tags: ['Flexibility', 'Stretch'],
        difficulty: 'beginner',
        category: 'flexibility',
        muscleGroups: ['hamstrings', 'lower back'],
        sets: 2,
        reps: 30,
      ),
    ];
  }
}
