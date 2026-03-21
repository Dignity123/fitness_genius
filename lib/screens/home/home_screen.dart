import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/quest_provider.dart';
import '../../models/quest.dart';
import 'widgets/streak_banner.dart';
import 'widgets/stats_row.dart';
import 'widgets/active_quest_card.dart';
import 'widgets/ai_tip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuestProvider>().loadQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FITNESS GENIUS'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Banner
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return StreakBanner(
                  currentStreak: userProvider.currentStreak,
                  longestStreak: userProvider.userProfile?.longestStreak ?? 0,
                );
              },
            ),
            const SizedBox(height: 24),

            // Stats Row
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return StatsRow(
                  totalXP: userProvider.totalXP,
                  currentLevel: userProvider.currentLevel,
                );
              },
            ),
            const SizedBox(height: 24),

            // Active Quests
            Text(
              'ACTIVE QUESTS',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Consumer<QuestProvider>(
              builder: (context, questProvider, _) {
                if (questProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                    ),
                  );
                }

                if (questProvider.activeQuests.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'No active quests. Create one to start!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questProvider.activeQuests.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ActiveQuestCard(
                        quest: questProvider.activeQuests[index],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // AI Tip
            const AITipCard(),
            const SizedBox(height: 24),

            // Quick Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('CREATE NEW QUEST'),
                onPressed: () => _showCreateQuestDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateQuestDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: const Text('CREATE NEW QUEST'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Quest Title',
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
              maxLines: 3,
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
              final quest = Quest(
                title: titleController.text,
                description: descriptionController.text,
                exerciseIds: [],
                targetReps: 50,
                targetSets: 5,
              );
              context.read<QuestProvider>().createQuest(quest);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quest created!')),
              );
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }
}