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
      final workouts = await _workoutDAO.getCompletedWorkoutSessions();
      final hydratedWorkouts = <WorkoutSession>[];

      for (final workout in workouts) {
        final logs = await _workoutDAO.getExerciseLogsBySessionId(workout.id);
        final hydratedLogs = <ExerciseLog>[];

        for (final log in logs) {
          final sets = await _workoutDAO.getWorkoutSetsByExerciseLogId(log.id);
          hydratedLogs.add(log.copyWith(sets: sets));
        }

        hydratedWorkouts.add(workout.copyWith(exerciseLogs: hydratedLogs));
      }

      _completedSessions = hydratedWorkouts;
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
    final updated = [..._currentSession!.exerciseLogs];
    final index = updated.indexWhere((e) => e.id == log.id);

    if (index != -1) {
      updated[index] = log;
    } else {
      updated.add(log);
    }

    _currentSession = _currentSession!.copyWith(exerciseLogs: updated);
    notifyListeners();
  }

  Future<void> completeWorkout({int? totalCalories, int? totalDuration}) async {
    if (_currentSession == null) return;

    final completedSession = _currentSession!.copyWith(
      isCompleted: true,
      endTime: DateTime.now(),
      totalCalories: totalCalories ?? 0,
      totalDuration: totalDuration ?? _currentSession!.getDuration(),
    );

    try {
      await _workoutDAO.insertWorkoutSession(completedSession);

      for (final log in completedSession.exerciseLogs) {
        await _workoutDAO.insertExerciseLog(log);
        for (final set in log.sets) {
          await _workoutDAO.insertWorkoutSet(set);
        }
      }

      _completedSessions.insert(0, completedSession);
      _currentSession = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing workout: $e');
      rethrow;
    }
  }

  void cancelWorkout() {
    _currentSession = null;
    notifyListeners();
  }

  void addWorkoutSession(WorkoutSession session) {
    _completedSessions.insert(0, session);
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
        .fold<int>(0, (sum, session) => sum + session.totalDuration);
  }
}
