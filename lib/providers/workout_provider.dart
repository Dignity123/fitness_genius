import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../database/workout_dao.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutSession? _currentSession;
  List<WorkoutSession> _completedSessions = [];
  bool _isLoading = false;
  final WorkoutDAO _workoutDAO = WorkoutDAO();

  WorkoutSession? get currentSession => _currentSession;
  List<WorkoutSession> get completedSessions => _completedSessions;
  List<WorkoutSession> get allWorkouts => _completedSessions;
  bool get isLoading => _isLoading;
  bool get hasActiveWorkout => _currentSession != null && !_currentSession!.isCompleted;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load workouts from database
      final workouts = await _workoutDAO.getAllWorkoutSessions();
      _completedSessions = workouts;
    } catch (e) {
      debugPrint('Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startWorkout(WorkoutSession session) {
    _currentSession = session;
    notifyListeners();
  }

  void addExerciseLog(ExerciseLog log) {
    if (_currentSession == null) return;
    _currentSession = _currentSession!.copyWith(
      exerciseLogs: [..._currentSession!.exerciseLogs, log],
    );
    notifyListeners();
  }

  void updateExerciseLog(ExerciseLog log) {
    if (_currentSession == null) return;
    final index = _currentSession!.exerciseLogs.indexWhere((e) => e.id == log.id);
    if (index != -1) {
      final updated = [..._currentSession!.exerciseLogs];
      updated[index] = log;
      _currentSession = _currentSession!.copyWith(exerciseLogs: updated);
      notifyListeners();
    }
  }

  void completeWorkout({int? totalCalories, int? totalDuration}) {
    if (_currentSession == null) return;
    
    _currentSession = _currentSession!.copyWith(
      isCompleted: true,
      endTime: DateTime.now(),
      totalCalories: totalCalories ?? 0,
      totalDuration: totalDuration ?? _currentSession!.getDuration(),
    );
    
    _completedSessions.add(_currentSession!);
    _currentSession = null;
    notifyListeners();
  }

  void cancelWorkout() {
    _currentSession = null;
    notifyListeners();
  }

  void addWorkoutSession(WorkoutSession session) {
    _completedSessions.add(session);
    notifyListeners();
  }

  List<WorkoutSession> getSessionsByMonth(int month, int year) {
    return _completedSessions.where((s) {
      return s.startTime.month == month && s.startTime.year == year;
    }).toList();
  }

  int getTotalWorkoutsThisMonth(int month, int year) {
    return getSessionsByMonth(month, year).length;
  }

  int getTotalMinutesThisMonth(int month, int year) {
    return getSessionsByMonth(month, year)
        .fold<int>(0, (sum, session) => sum + session.getDuration());
  }
}