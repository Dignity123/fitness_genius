import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/date_utils.dart';

class WeekSelector extends StatelessWidget {
  final DateTime selectedWeek;
  final Function(DateTime) onWeekChanged;

  const WeekSelector({
    Key? key,
    required this.selectedWeek,
    required this.onWeekChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekStart = DateUtil.startOfWeek(selectedWeek);
    final weekEnd = DateUtil.endOfWeek(selectedWeek);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'WEEK OF ${DateUtil.formatDate(weekStart)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    onWeekChanged(selectedWeek.subtract(const Duration(days: 7)));
                  },
                ),
                Text(
                  '${DateUtil.formatDate(weekStart)} - ${DateUtil.formatDate(weekEnd)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    onWeekChanged(selectedWeek.add(const Duration(days: 7)));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}