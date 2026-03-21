import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StatsRow extends StatelessWidget {
  final int totalXP;
  final int currentLevel;

  const StatsRow({
    Key? key,
    required this.totalXP,
    required this.currentLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final xpForNextLevel = currentLevel * 1000;
    final xpInCurrentLevel = totalXP % 1000;
    final progress = xpInCurrentLevel / 1000;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currentLevel',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'XP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              letterSpacing: 2,
                            ),
                      ),
                      Text(
                        '$xpInCurrentLevel / 1000',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accentGreen,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.accentGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}