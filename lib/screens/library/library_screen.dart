import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/exercise_provider.dart';
import '../../utils/constants.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/tag_filter_row.dart';
import 'widgets/difficulty_filter_row.dart';
import 'widgets/exercise_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExerciseProvider>().loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXERCISE LIBRARY'),
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, _) {
          return Column(
            children: [
              // Search Bar
              SearchBarWidget(
                onChanged: (value) {
                  exerciseProvider.setSearchQuery(value);
                },
              ),

              // Filters
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter
                    TagFilterRow(
                      title: 'CATEGORY',
                      tags: AppConstants.exerciseCategories,
                      selectedTag: exerciseProvider.selectedCategory,
                      onTagSelected: (tag) {
                        exerciseProvider.setSelectedCategory(tag);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Difficulty Filter
                    DifficultyFilterRow(
                      selectedDifficulty: exerciseProvider.selectedDifficulty,
                      onDifficultySelected: (difficulty) {
                        exerciseProvider.setSelectedDifficulty(difficulty);
                      },
                    ),
                  ],
                ),
              ),

              // Exercise List
              Expanded(
                child: exerciseProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentGreen,
                          ),
                        ),
                      )
                    : exerciseProvider.filteredExercises.isEmpty
                        ? Center(
                            child: Text(
                              'No exercises found',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: exerciseProvider.filteredExercises.length,
                            itemBuilder: (context, index) {
                              final exercise =
                                  exerciseProvider.filteredExercises[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ExerciseCardWidget(
                                  exercise: exercise,
                                  onFavoriteTap: () {
                                    exerciseProvider.toggleFavorite(exercise.id);
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentGreen,
        foregroundColor: AppTheme.primaryDark,
        onPressed: () => _showCreateExerciseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'strength';
    String selectedDifficulty = 'intermediate';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: const Text('CREATE EXERCISE'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Exercise Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Create exercise
              Navigator.pop(context);
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }
}