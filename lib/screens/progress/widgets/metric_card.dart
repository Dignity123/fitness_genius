import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String change;
  final bool isPositive;

  const MetricCard({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
    required this.change,
    required this.isPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentGreen,
                          ),
                    ),
                    Text(
                      unit,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 14,
                          color: isPositive
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          change,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isPositive
                                    ? AppTheme.successGreen
                                    : AppTheme.errorRed,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      'vs last week',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}