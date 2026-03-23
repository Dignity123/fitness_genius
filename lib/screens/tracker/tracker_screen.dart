import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../models/workout_session.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  bool _isWorkoutActive = false;
  int _elapsedSeconds = 0;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _startQuickWorkout(String workoutType) {
    final workoutProvider = context.read<WorkoutProvider>();
    
    final newWorkout = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questId: 'quick_workout_${DateTime.now().millisecondsSinceEpoch}',
      name: workoutType,
      startTime: DateTime.now(),
      endTime: null,
      isCompleted: false,
      totalCalories: 0,
      totalDuration: 0,
    );

    workoutProvider.startWorkout(newWorkout);
    
    setState(() {
      _isWorkoutActive = true;
      _elapsedSeconds = 0;
    });

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$workoutType workout started! 💪'),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _pauseWorkout() {
    _stopTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Workout paused'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
  }

  void _completeWorkout() {
    final workoutProvider = context.read<WorkoutProvider>();
    
    if (workoutProvider.currentSession != null) {
      final completedWorkout = workoutProvider.currentSession!.copyWith(
        endTime: DateTime.now(),
        isCompleted: true,
        totalDuration: _elapsedSeconds ~/ 60,
        totalCalories: (_elapsedSeconds ~/ 60 * 8).toInt(), // ~8 calories per minute
      );

      // Save to database
      workoutProvider.completeWorkout();

      setState(() {
        _isWorkoutActive = false;
        _elapsedSeconds = 0;
      });

      _stopTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Workout completed! ${_formatTime(_elapsedSeconds)} • ${completedWorkout.totalCalories} calories 🔥',
          ),
          backgroundColor: AppTheme.accentGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKOUT TRACKER'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholder3.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppTheme.primaryDark);
              },
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active Workout Card
                GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isWorkoutActive ? 'ACTIVE WORKOUT' : 'START WORKOUT',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          if (_isWorkoutActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'RUNNING',
                                style: TextStyle(
                                  color: AppTheme.primaryDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _formatTime(_elapsedSeconds),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      if (_isWorkoutActive) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('Calories', '${(_elapsedSeconds ~/ 60 * 8)}', context),
                            _buildStatItem('Time', _formatTime(_elapsedSeconds), context),
                            _buildStatItem('Active', '💪', context),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _pauseWorkout,
                                icon: const Icon(Icons.pause),
                                label: const Text('PAUSE'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _completeWorkout,
                                icon: const Icon(Icons.check),
                                label: const Text('FINISH'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Start Section
                Text(
                  'QUICK START',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentGreen,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),

                // Quick Workouts
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickWorkout('Running', Icons.directions_run, context, () {
                      _startQuickWorkout('Running');
                    }),
                    _buildQuickWorkout('Cycling', Icons.directions_bike, context, () {
                      _startQuickWorkout('Cycling');
                    }),
                    _buildQuickWorkout('Swimming', Icons.pool, context, () {
                      _startQuickWorkout('Swimming');
                    }),
                    _buildQuickWorkout('Gym', Icons.fitness_center, context, () {
                      _startQuickWorkout('Gym');
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.accentGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickWorkout(String name, IconData icon, BuildContext context, VoidCallback onTap) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: _isWorkoutActive ? null : onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _isWorkoutActive ? AppTheme.textSecondary : AppTheme.accentGreen,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: _isWorkoutActive ? AppTheme.textSecondary : null,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}