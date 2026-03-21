import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/exercise.dart';

class ExerciseCardWidget extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onFavoriteTap;

  const ExerciseCardWidget({
    Key? key,
    required this.exercise,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    exercise.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: exercise.isFavorite
                        ? AppTheme.errorRed
                        : AppTheme.textSecondary,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(exercise.category.toUpperCase()),
                  backgroundColor: AppTheme.accentGreen,
                  labelStyle: const TextStyle(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(exercise.difficulty.toUpperCase()),
                  backgroundColor: _getDifficultyColor(),
                  labelStyle: const TextStyle(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              exercise.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.repeat, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.sets}×${exercise.reps}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                if (exercise.equipment != null)
                  Text(
                    exercise.equipment!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.accentGreen),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (exercise.difficulty) {
      case 'beginner':
        return AppTheme.infoBlue;
      case 'intermediate':
        return AppTheme.warningOrange;
      case 'advanced':
        return AppTheme.errorRed;
      default:
        return AppTheme.accentGreen;
    }
  }
}