import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StreakBanner extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const StreakBanner({
    Key? key,
    required this.currentStreak,
    required this.longestStreak,
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
              AppTheme.accentGreen.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STREAK',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppTheme.warningOrange,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$currentStreak',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.accentGreen,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'days',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'BEST STREAK',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$longestStreak days',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.accentGreen,
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