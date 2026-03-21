import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class AITipCard extends StatelessWidget {
  const AITipCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Consistency beats intensity. Aim for 3-4 workouts per week.',
      'Rest days are crucial for muscle recovery and growth.',
      'Track your progress with photos - visual changes take time.',
      'Progressive overload: gradually increase weight or reps.',
      'Stay hydrated and maintain proper form over ego lifting.',
    ];

    final randomTip = tips[DateTime.now().millisecond % tips.length];

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
              AppTheme.infoBlue.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.lightbulb,
              color: AppTheme.infoBlue,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI TIP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.infoBlue,
                          letterSpacing: 2,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    randomTip,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}