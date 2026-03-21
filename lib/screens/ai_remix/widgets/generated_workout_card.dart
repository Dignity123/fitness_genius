import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class GeneratedWorkoutCard extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onStart;

  const GeneratedWorkoutCard({
    Key? key,
    required this.workout,
    required this.onStart,
  }) : super(key: key);

  Color _getIntensityColor() {
    final intensity = (workout['intensity'] as String).toLowerCase();
    switch (intensity) {
      case 'light':
        return AppTheme.infoBlue;
      case 'moderate':
        return AppTheme.warningOrange;
      case 'intense':
        return AppTheme.errorRed;
      default:
        return AppTheme.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = workout['exercises'] as List<dynamic>;
    final intensity = workout['intensity'] as String;
    final duration = workout['duration'] as int;
    final reason = workout['reason'] as String;
    final name = workout['name'] as String;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getIntensityColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    intensity.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 12),
            // Exercise List
            Text(
              'EXERCISES',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 8),
            ...exercises.map((exercise) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: AppTheme.accentGreen,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exercise.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 12),
            // Duration and Start Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '~${duration}m',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('START'),
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}