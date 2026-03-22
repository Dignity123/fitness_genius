import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'database/database_helper.dart';
import 'database/quest_dao.dart';
import 'database/exercise_dao.dart';
import 'providers/quest_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/user_provider.dart';
import 'navigation/bottom_nav.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
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
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness Genius',
        theme: AppTheme.darkTheme,
        home: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            return userProvider.isLoggedIn ? const BottomNavBar() : const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const BottomNavBar(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}