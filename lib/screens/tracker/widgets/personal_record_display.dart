import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PersonalRecordDisplay extends StatelessWidget {
  final String exerciseName;
  final double maxWeight;
  final int maxReps;

  const PersonalRecordDisplay({
    Key? key,
    required this.exerciseName,
    required this.maxWeight,
    required this.maxReps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryDark,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.secondaryDark,
              AppTheme.warningOrange.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppTheme.warningOrange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'PERSONAL RECORDS',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningOrange,
                        letterSpacing: 2,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max Weight',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maxWeight > 0
                          ? '${maxWeight.toStringAsFixed(1)} lbs'
                          : 'Not logged yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentGreen,
                          ),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppTheme.borderColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Max Reps',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maxReps > 0 ? '$maxReps reps' : 'Not logged yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentGreen,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}