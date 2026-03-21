import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/workout_provider.dart';
import '../../models/workout_session.dart';
import 'widgets/set_log_table.dart';
import 'widgets/rest_timer_widget.dart';
import 'widgets/workout_header.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORKOUT TRACKER'),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, _) {
          if (!workoutProvider.hasActiveWorkout) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active workout',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _startNewWorkout(context),
                    child: const Text('START WORKOUT'),
                  ),
                ],
              ),
            );
          }

          final session = workoutProvider.currentSession!;
          final duration = session.getDuration();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workout Header
                WorkoutHeader(
                  sessionName: session.name,
                  duration: duration,
                  startTime: session.startTime,
                ),
                const SizedBox(height: 24),

                // Rest Timer
                const RestTimerWidget(),
                const SizedBox(height: 24),

                // Exercise Logs
                Text(
                  'EXERCISES',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                if (session.exerciseLogs.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No exercises logged yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: session.exerciseLogs.length,
                    itemBuilder: (context, index) {
                      final exerciseLog = session.exerciseLogs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exerciseLog.exerciseName.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppTheme.accentGreen,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                SetLogTable(exerciseLog: exerciseLog),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('CANCEL'),
                        onPressed: () {
                          workoutProvider.cancelWorkout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Workout cancelled')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.errorRed),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('FINISH'),
                        onPressed: () {
                          workoutProvider.completeWorkout(
                            totalCalories: 350,
                            totalDuration: duration,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Workout completed! +500 XP'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startNewWorkout(BuildContext context) {
    final session = WorkoutSession(
      questId: 'quest_1',
      name: 'New Workout',
    );
    context.read<WorkoutProvider>().startWorkout(session);
  }
}