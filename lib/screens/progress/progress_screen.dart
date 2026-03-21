import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/progress_provider.dart';
import 'widgets/week_selector.dart';
import 'widgets/photo_comparison.dart';
import 'widgets/metric_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _selectedWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProgressProvider>().loadProgressEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRESS TRACKING'),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Week Selector
                WeekSelector(
                  selectedWeek: _selectedWeek,
                  onWeekChanged: (newWeek) {
                    setState(() {
                      _selectedWeek = newWeek;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Photo Comparison
                Text(
                  'PHOTO TIMELINE',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                const PhotoComparison(),
                const SizedBox(height: 24),

                // Body Metrics
                Text(
                  'BODY METRICS',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MetricCard(
                      label: 'WEIGHT',
                      value: '185',
                      unit: 'lbs',
                      change: '-2.5',
                      isPositive: true,
                    ),
                    MetricCard(
                      label: 'CHEST',
                      value: '40',
                      unit: 'in',
                      change: '+0.5',
                      isPositive: true,
                    ),
                    MetricCard(
                      label: 'WAIST',
                      value: '32',
                      unit: 'in',
                      change: '-1',
                      isPositive: true,
                    ),
                    MetricCard(
                      label: 'ARMS',
                      value: '14',
                      unit: 'in',
                      change: '+0.75',
                      isPositive: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Add Metrics Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('LOG METRICS'),
                    onPressed: () => _showLogMetricsDialog(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogMetricsDialog(BuildContext context) {
    final weightController = TextEditingController();
    final chestController = TextEditingController();
    final waistController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryDark,
        title: const Text('LOG BODY METRICS'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  hintText: 'Weight (lbs)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: chestController,
                decoration: const InputDecoration(
                  hintText: 'Chest (in)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: waistController,
                decoration: const InputDecoration(
                  hintText: 'Waist (in)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              // TODO: Save metrics
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Metrics logged!')),
              );
            },
            child: const Text('LOG'),
          ),
        ],
      ),
    );
  }
}