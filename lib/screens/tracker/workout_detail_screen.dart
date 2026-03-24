// lib/screens/tracker/workout_detail_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/workout_session.dart';
import '../../utils/date_utils.dart';
import 'widgets/workout_header.dart';
import 'widgets/set_log_table.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutSession workout;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Header
            WorkoutHeader(
              sessionName: workout.name,
              duration: workout.totalDuration,
              startTime: workout.startTime,
            ),
            const SizedBox(height: 24),

            // Exercises
            Text(
              'EXERCISES',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),

            ...workout.exerciseLogs.map((log) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.exerciseName.toUpperCase(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.accentGreen,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (log.notes?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Notes: ${log.notes}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          SetLogTable(exerciseLog: log),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),

            // Workout Notes
            if (workout.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 24),
              Text(
                'NOTES',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    workout.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}