// lib/screens/exercise/exercise_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/exercise.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/workout_provider.dart';
import '../tracker/widgets/technique_tips.dart';
import '../tracker/widgets/muscle_groups_display.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  late Exercise _currentExercise;

  @override
  void initState() {
    super.initState();
    _currentExercise = widget.exercise;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentExercise.name.toUpperCase()),
        actions: [
          Consumer<ExerciseProvider>(
            builder: (context, exerciseProvider, _) {
              return IconButton(
                icon: Icon(
                  _currentExercise.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _currentExercise.isFavorite
                      ? AppTheme.errorRed
                      : AppTheme.textSecondary,
                ),
                onPressed: () {
                  exerciseProvider.toggleFavorite(_currentExercise.id);
                  setState(() {
                    _currentExercise = _currentExercise.copyWith(
                      isFavorite: !_currentExercise.isFavorite,
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Header
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Category & Difficulty
            _buildCategoryDifficultyRow(),
            const SizedBox(height: 24),

            // Description
            _buildDescription(),
            const SizedBox(height: 24),

            // Muscle Groups
            _buildMuscleGroups(),
            const SizedBox(height: 24),

            // Technique Tips
            if (_currentExercise.technique != null && _currentExercise.technique!.isNotEmpty)
              _buildTechniqueTips(),
            const SizedBox(height: 24),

            // Equipment
            if (_currentExercise.equipment != null)
              _buildEquipment(),
            const SizedBox(height: 24),

            // Target Reps & Sets
            _buildTargetStats(),
            const SizedBox(height: 24),

            // Add to Workout Button
            _buildAddButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
              _currentExercise.name.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.accentGreen,
              ),
            ),
            const SizedBox(height: 12),
            if (_currentExercise.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _currentExercise.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.2),
                      border: Border.all(color: AppTheme.accentGreen),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentGreen,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDifficultyRow() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'CATEGORY',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentExercise.category.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'DIFFICULTY',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _currentExercise.difficulty.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.bold,
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

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT THIS EXERCISE',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _currentExercise.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MUSCLE GROUPS',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        MuscleGroupsDisplay(muscleGroups: _currentExercise.muscleGroups),
      ],
    );
  }

  Widget _buildTechniqueTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROPER FORM & TECHNIQUE',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        TechniqueTips(tips: _currentExercise.technique!),
      ],
    );
  }

  Widget _buildEquipment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EQUIPMENT NEEDED',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: AppTheme.accentGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentExercise.equipment!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDED',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'SETS',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_currentExercise.sets}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'REPS',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_currentExercise.reps}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('ADD TO WORKOUT'),
        onPressed: _showAddToWorkoutDialog,
      ),
    );
  }

  void _showAddToWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: const Text('ADD TO WORKOUT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add ${_currentExercise.name} to your active workout',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Default: ${_currentExercise.sets} sets × ${_currentExercise.reps} reps',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WorkoutProvider>().addExerciseToWorkout(
                exerciseId: _currentExercise.id,
                exerciseName: _currentExercise.name,
                targetSets: _currentExercise.sets ?? 3,
                targetReps: _currentExercise.reps ?? 10,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_currentExercise.name} added to workout!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (_currentExercise.difficulty) {
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