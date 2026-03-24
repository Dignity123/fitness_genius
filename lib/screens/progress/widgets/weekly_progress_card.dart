import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_card.dart';

class WeeklyProgressCard extends StatelessWidget {
  final String title;
  final Map<String, String> values;

  const WeeklyProgressCard({
    Key? key,
    required this.title,
    required this.values,
  }) : super(key: key);

  Color _getValueColor(String value) {
    if (value == '--') return AppTheme.textSecondary;
    if (value.startsWith('+')) return AppTheme.accentGreen;
    if (value.startsWith('-')) return Colors.orangeAccent;
    return AppTheme.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: values.entries.map((entry) {
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 34,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.accentGreen.withOpacity(0.35),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.03),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _getValueColor(entry.value),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
