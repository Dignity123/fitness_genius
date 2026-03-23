import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/workout_set.dart';

class SetInputCard extends StatefulWidget {
  final WorkoutSet set;
  final Function(WorkoutSet) onUpdate;
  final VoidCallback onDelete;

  const SetInputCard({
    Key? key,
    required this.set,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<SetInputCard> createState() => _SetInputCardState();
}

class _SetInputCardState extends State<SetInputCard> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _notesController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController(text: widget.set.reps.toString());
<<<<<<< HEAD
    _weightController = TextEditingController(text: widget.set.weight.toString());
=======
    _weightController =
        TextEditingController(text: widget.set.weight.toString());
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
    _notesController = TextEditingController(text: widget.set.notes ?? '');
    _isCompleted = widget.set.isCompleted;
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SET ${widget.set.setNumber}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentGreen,
                      ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() {
                          _isCompleted = value ?? false;
                          _updateSet();
                        });
                      },
                      activeColor: AppTheme.accentGreen,
                    ),
                    Text(
                      'Complete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppTheme.errorRed,
                      onPressed: widget.onDelete,
                      iconSize: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reps',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateSet(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight (lbs)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _updateSet(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _notesController,
                  onChanged: (_) => _updateSet(),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'RPE, form notes, pain, etc.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateSet() {
    final updatedSet = widget.set.copyWith(
      reps: int.tryParse(_repsController.text) ?? 0,
<<<<<<< HEAD
      weight: double.tryParse(_weightController.text) ?? 0,
=======
      weight: int.tryParse(_weightController.text) ?? 0,
>>>>>>> 1f8dcb1 (Added some functionalities to tracker and history)
      notes: _notesController.text,
      isCompleted: _isCompleted,
    );
    widget.onUpdate(updatedSet);
  }
}