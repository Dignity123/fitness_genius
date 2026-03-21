import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/date_utils.dart';

class WorkoutHeader extends StatelessWidget {
  final String sessionName;
  final int duration;
  final DateTime startTime;

  const WorkoutHeader({
    Key? key,
    required this.sessionName,
    required this.duration,
    required this.startTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.secondaryDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sessionName.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.accentGreen,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateUtil.formatDateTime(startTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: AppTheme.accentGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  DateUtil.formatDuration(Duration(minutes: duration)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
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