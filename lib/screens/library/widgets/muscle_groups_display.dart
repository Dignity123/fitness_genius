import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MuscleGroupsDisplay extends StatelessWidget {
  final List<String> muscleGroups;

  const MuscleGroupsDisplay({
    Key? key,
    required this.muscleGroups,
  }) : super(key: key);

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return AppTheme.errorRed;
      case 'back':
        return AppTheme.infoBlue;
      case 'shoulders':
        return AppTheme.warningOrange;
      case 'biceps':
      case 'triceps':
        return AppTheme.successGreen;
      case 'forearms':
        return AppTheme.accentGreen;
      case 'legs':
      case 'quads':
      case 'hamstrings':
        return AppTheme.infoBlue;
      case 'calves':
        return AppTheme.warningOrange;
      case 'core':
      case 'abs':
        return AppTheme.accentGreen;
      case 'glutes':
        return AppTheme.errorRed;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (muscleGroups.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No muscle groups specified',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: muscleGroups.map((muscle) {
        final color = _getMuscleColor(muscle);
        return Chip(
          label: Text(muscle.toUpperCase()),
          backgroundColor: color.withOpacity(0.2),
          side: BorderSide(color: color),
          labelStyle: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
  }
}