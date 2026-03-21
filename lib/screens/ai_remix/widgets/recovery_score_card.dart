import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class RecoveryScoreCard extends StatelessWidget {
  final double recoveryScore;

  const RecoveryScoreCard({
    Key? key,
    this.recoveryScore = 0.75,
  }) : super(key: key);

  Color _getRecoveryColor() {
    if (recoveryScore >= 0.8) {
      return AppTheme.successGreen;
    } else if (recoveryScore >= 0.6) {
      return AppTheme.warningOrange;
    } else {
      return AppTheme.errorRed;
    }
  }

  String _getRecoveryStatus() {
    if (recoveryScore >= 0.8) {
      return 'FULLY RECOVERED';
    } else if (recoveryScore >= 0.6) {
      return 'RECOVERING';
    } else {
      return 'NEEDS REST';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRecoveryColor();
    final status = _getRecoveryStatus();

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
              color.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RECOVERY STATUS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can do moderate to intense workouts',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 94,
                        height: 94,
                        child: CircularProgressIndicator(
                          value: recoveryScore,
                          strokeWidth: 3,
                          backgroundColor: AppTheme.primaryDark,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      Text(
                        '${(recoveryScore * 100).toInt()}%',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: color,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: recoveryScore,
                minHeight: 6,
                backgroundColor: AppTheme.primaryDark,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(
                  context,
                  'Hours',
                  'Since Last Workout',
                  '18',
                ),
                _buildStat(
                  context,
                  'Sleep',
                  'Last Night',
                  '7.5 hrs',
                ),
                _buildStat(
                  context,
                  'Fatigue',
                  'Level',
                  '25%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String sublabel,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentGreen,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          sublabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}