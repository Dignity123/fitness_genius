import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/exercise_provider.dart';
import '../../utils/constants.dart';
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholder2.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.1),
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppTheme.primaryDark);
              },
            ),
          ),
          // Content
          Consumer<ExerciseProvider>(
            builder: (context, exerciseProvider, _) {
              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SearchBarWidget(
                      onChanged: (value) {
                        exerciseProvider.setSearchQuery(value);
                      },
                    ),
                  ),

                  // Filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Difficulty Filter
                        DifficultyFilterRow(
                          selectedDifficulty: 'All',
                          onDifficultySelected: (difficulty) {
                            exerciseProvider.setSelectedDifficulty(difficulty);
                          },
                        ),
                        const SizedBox(height: 12),

                        // Tag Filter
                        TagFilterRow(
                          title: 'TAGS',
                          tags: ['All', 'Cardio', 'Strength', 'Flexibility'],
                          selectedTag: 'All',
                          onTagSelected: (tag) {
                            // Filter by tag
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

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