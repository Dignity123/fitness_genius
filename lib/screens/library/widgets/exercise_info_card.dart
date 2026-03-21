import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/exercise.dart';

class ExerciseInfoCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseInfoCard({
    Key? key,
    required this.exercise,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.accentGreen,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoTag(context, 'difficulty', exercise.difficulty),
                const SizedBox(width: 8),
                _buildInfoTag(context, 'category', exercise.category),
              ],
            ),
            if (exercise.tags.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: exercise.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withOpacity(0.2),
                          border: Border.all(color: AppTheme.accentGreen),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.accentGreen,
                                    fontSize: 11,
                                  ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border.all(color: AppTheme.accentGreen),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.accentGreen,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}