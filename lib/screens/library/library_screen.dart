import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/exercise_provider.dart';
<<<<<<< HEAD
import '../../utils/constants.dart';
=======
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
import '../../widgets/glassmorphic_card.dart';
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
        elevation: 0,
      ),
      body: Stack(
        children: [
<<<<<<< HEAD
          // Background Image
=======
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholder2.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppTheme.primaryDark);
              },
            ),
          ),
<<<<<<< HEAD
          // Content
=======
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
          Consumer<ExerciseProvider>(
            builder: (context, exerciseProvider, _) {
              return Column(
                children: [
<<<<<<< HEAD
                  // Search Bar
=======
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SearchBarWidget(
                      onChanged: (value) {
                        exerciseProvider.setSearchQuery(value);
                      },
                    ),
                  ),
<<<<<<< HEAD

                  // Filters
=======
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        // Difficulty Filter
                        DifficultyFilterRow(
                          selectedDifficulty: 'All',
=======
                        DifficultyFilterRow(
                          selectedDifficulty: exerciseProvider.selectedDifficulty,
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
                          onDifficultySelected: (difficulty) {
                            exerciseProvider.setSelectedDifficulty(difficulty);
                          },
                        ),
                        const SizedBox(height: 12),
<<<<<<< HEAD

                        // Tag Filter
                        TagFilterRow(
                          title: 'TAGS',
                          tags: ['All', 'Cardio', 'Strength', 'Flexibility'],
                          selectedTag: 'All',
                          onTagSelected: (tag) {
                            // Filter by tag
=======
                        TagFilterRow(
                          title: 'CATEGORY',
                          tags: const [
                            'cardio',
                            'strength',
                            'flexibility',
                            'balance',
                          ],
                          selectedTag: exerciseProvider.selectedCategory,
                          onTagSelected: (tag) {
                            exerciseProvider.setSelectedCategory(tag);
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
<<<<<<< HEAD

                  // Exercises List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: exerciseProvider.filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exerciseProvider.filteredExercises[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ExerciseCardWidget(
                            exercise: exercise,
                            onFavoriteTap: () {
                              // Toggle favorite
                            },
                          ),
                        );
                      },
                    ),
=======
                  Expanded(
                    child: exerciseProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : exerciseProvider.filteredExercises.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: GlassmorphicCard(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'No exercises found.\nTry clearing your filters or search.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount:
                                    exerciseProvider.filteredExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise =
                                      exerciseProvider.filteredExercises[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    child: ExerciseCardWidget(
                                      exercise: exercise,
                                      onFavoriteTap: () {
                                        exerciseProvider
                                            .toggleFavorite(exercise.id);
                                      },
                                    ),
                                  );
                                },
                              ),
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}