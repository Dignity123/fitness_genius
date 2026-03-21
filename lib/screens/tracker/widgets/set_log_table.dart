import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/workout_session.dart';

class SetLogTable extends StatelessWidget {
  final ExerciseLog exerciseLog;

  const SetLogTable({
    Key? key,
    required this.exerciseLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.8),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: AppTheme.borderColor),
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            color: AppTheme.secondaryDark,
          ),
          children: [
            _buildTableCell('SET', context, isHeader: true),
            _buildTableCell('REPS', context, isHeader: true),
            _buildTableCell('WEIGHT', context, isHeader: true),
            _buildTableCell('✓', context, isHeader: true),
          ],
        ),
        // Data rows
        ...exerciseLog.sets.map((set) {
          return TableRow(
            children: [
              _buildTableCell('${set.setNumber}', context),
              _buildTableCell('${set.reps}', context),
              _buildTableCell('${set.weight} lbs', context),
              _buildTableCell(
                set.isCompleted ? '✓' : '○',
                context,
                color: set.isCompleted
                    ? AppTheme.successGreen
                    : AppTheme.textSecondary,
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTableCell(
    String text,
    BuildContext context, {
    bool isHeader = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isHeader
            ? Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                )
            : Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
      ),
    );
  }
}