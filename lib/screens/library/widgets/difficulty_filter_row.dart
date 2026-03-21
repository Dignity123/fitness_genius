import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/constants.dart';

class DifficultyFilterRow extends StatelessWidget {
  final String selectedDifficulty;
  final Function(String) onDifficultySelected;

  const DifficultyFilterRow({
    Key? key,
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DIFFICULTY',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 2,
              ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.difficultyLevels.map((difficulty) {
              final isSelected = selectedDifficulty == difficulty;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(difficulty.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    onDifficultySelected(selected ? difficulty : '');
                  },
                  backgroundColor: AppTheme.secondaryDark,
                  selectedColor: _getDifficultyColor(difficulty),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return AppTheme.infoBlue;
      case 'intermediate':
        return AppTheme.accentGreen;
      case 'advanced':
        return AppTheme.errorRed;
      default:
        return AppTheme.accentGreen;
    }
  }
}