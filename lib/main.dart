import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'database/database_helper.dart';
import 'database/quest_dao.dart';
import 'database/exercise_dao.dart';
import 'services/preferences_service.dart';
import 'providers/quest_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/progress_provider.dart';
import 'navigation/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper().database;
  
  // Initialize SharedPreferences
  await PreferencesService().initialize();
  
  runApp(const FitnessGeniusApp());
}

class FitnessGeniusApp extends StatelessWidget {
  const FitnessGeniusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuestDAO>(create: (_) => QuestDAO()),
        Provider<ExerciseDAO>(create: (_) => ExerciseDAO()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness Genius',
        theme: AppTheme.darkTheme,
        home: const BottomNavBar(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}