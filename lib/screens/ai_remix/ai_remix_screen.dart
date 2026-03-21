import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/workout_provider.dart';
import 'widgets/recovery_score_card.dart';
import 'widgets/intensity_slider.dart';
import 'widgets/generated_workout_card.dart';

class AIRemixScreen extends StatefulWidget {
  const AIRemixScreen({Key? key}) : super(key: key);

  @override
  State<AIRemixScreen> createState() => _AIRemixScreenState();
}

class _AIRemixScreenState extends State<AIRemixScreen> {
  double _selectedIntensity = 0.5;
  bool _isGenerating = false;
  List<Map<String, dynamic>> _generatedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _generateInitialRecommendations();
  }

  void _generateInitialRecommendations() {
    _generatedWorkouts = [
      {
        'name': 'Upper Body Push',
        'exercises': ['Bench Press', 'Incline Dumbbell Press', 'Cable Flyes'],
        'duration': 45,
        'intensity': 'moderate',
        'reason': 'Based on your recovery level and workout history',
      },
      {
        'name': 'Lower Body Focus',
        'exercises': ['Squats', 'Leg Press', 'Leg Curls', 'Calf Raises'],
        'duration': 50,
        'intensity': 'moderate',
        'reason': 'Targets weak areas in your routine',
      },
      {
        'name': 'Full Body Circuit',
        'exercises': ['Deadlifts', 'Pull-ups', 'Push-ups', 'Burpees'],
        'duration': 40,
        'intensity': 'intense',
        'reason': 'Great for building overall strength and endurance',
      },
    ];
  }

  Future<void> _generateNewWorkouts() async {
    setState(() {
      _isGenerating = true;
    });

    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isGenerating = false;
      _generateInitialRecommendations();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workouts generated based on your recovery!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI REMIX TRAINER'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recovery Score
            RecoveryScoreCard(),
            const SizedBox(height: 24),

            // Intensity Slider
            Text(
              'WORKOUT INTENSITY',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            IntensitySlider(
              value: _selectedIntensity,
              onChanged: (value) {
                setState(() {
                  _selectedIntensity = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // AI Recommendation Info
            Card(
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
                      Icons.smart_toy,
                      color: AppTheme.infoBlue,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI RECOMMENDATIONS',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.infoBlue,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Generated based on your recovery level, streak, and fitness goals',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isGenerating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryDark,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(
                  _isGenerating ? 'GENERATING...' : 'GENERATE WORKOUTS',
                ),
                onPressed: _isGenerating ? null : _generateNewWorkouts,
              ),
            ),
            const SizedBox(height: 24),

            // Generated Workouts
            Text(
              'RECOMMENDED WORKOUTS',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _generatedWorkouts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GeneratedWorkoutCard(
                    workout: _generatedWorkouts[index],
                    onStart: () {
                      // Start workout
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Starting ${_generatedWorkouts[index]['name']}!'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Tips Section
            Text(
              'TRAINING TIPS',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTipRow(
                      context,
                      '💪',
                      'Progressive Overload',
                      'Gradually increase weight or reps to keep challenging your muscles.',
                    ),
                    const SizedBox(height: 12),
                    _buildTipRow(
                      context,
                      '😴',
                      'Recovery Matters',
                      'Adequate sleep and rest days are crucial for muscle growth.',
                    ),
                    const SizedBox(height: 12),
                    _buildTipRow(
                      context,
                      '🥗',
                      'Nutrition First',
                      'You can\'t out-train a bad diet. Fuel your body properly.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow(
    BuildContext context,
    String emoji,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.accentGreen,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}