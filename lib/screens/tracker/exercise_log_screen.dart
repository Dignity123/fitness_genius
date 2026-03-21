import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/workout_session.dart';
import '../../models/workout_set.dart';
import '../../providers/workout_provider.dart';
import 'widgets/set_input_card.dart';
import 'widgets/personal_record_display.dart';

class ExerciseLogScreen extends StatefulWidget {
  final ExerciseLog exerciseLog;
  final String sessionId;

  const ExerciseLogScreen({
    Key? key,
    required this.exerciseLog,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<ExerciseLogScreen> createState() => _ExerciseLogScreenState();
}

class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
  late List<WorkoutSet> _sets;
  late ExerciseLog _currentLog;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sets = List.from(widget.exerciseLog.sets);
    _currentLog = widget.exerciseLog;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentLog.exerciseName.toUpperCase()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveExerciseLog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Record Display
            PersonalRecordDisplay(
              exerciseName: _currentLog.exerciseName,
              maxWeight: _getMaxWeight(),
              maxReps: _getMaxReps(),
            ),
            const SizedBox(height: 24),

            // Exercise Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL REPS',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_getTotalReps()}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.accentGreen,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL WEIGHT',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_getTotalWeight()} lbs',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.accentGreen,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SETS',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                letterSpacing: 1.5,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_sets.length}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.accentGreen,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sets List
            Text(
              'SET LOGS',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SetInputCard(
                    set: _sets[index],
                    onUpdate: (updatedSet) {
                      setState(() {
                        _sets[index] = updatedSet;
                      });
                    },
                    onDelete: () {
                      setState(() {
                        _sets.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Add Set Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('ADD SET'),
                onPressed: _addNewSet,
              ),
            ),
            const SizedBox(height: 24),

            // Notes Section
            Text(
              'NOTES',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Add notes about this exercise...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppTheme.accentGreen, width: 2),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('CANCEL'),
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.errorRed),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('SAVE'),
                    onPressed: _saveExerciseLog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addNewSet() {
    final newSetNumber = _sets.isNotEmpty
        ? (_sets.map((s) => s.setNumber).reduce((a, b) => a > b ? a : b) + 1)
        : 1;

    final newSet = WorkoutSet(
      exerciseLogId: _currentLog.id,
      setNumber: newSetNumber,
      reps: 10,
      weight: 0,
    );

    setState(() {
      _sets.add(newSet);
    });
  }

  void _saveExerciseLog() {
    // Update exercise log with current sets and notes
    final updatedLog = _currentLog.copyWith(
      sets: _sets,
      totalReps: _getTotalReps(),
      totalWeight: _getTotalWeight(),
      notes: _noteController.text,
    );

    // Save to provider
    context.read<WorkoutProvider>().updateExerciseLog(updatedLog);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise log saved!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  int _getTotalReps() {
    return _sets.fold<int>(0, (sum, set) => sum + set.reps);
  }

  double _getTotalWeight() {
    return _sets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));
  }

  double _getMaxWeight() {
    if (_sets.isEmpty) return 0;
    return _sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
  }

  int _getMaxReps() {
    if (_sets.isEmpty) return 0;
    return _sets.map((s) => s.reps).reduce((a, b) => a > b ? a : b);
  }
}