import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class TechniqueTips extends StatelessWidget {
  final String tips;

  const TechniqueTips({
    Key? key,
    required this.tips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tipsList = tips.split('|').where((t) => t.trim().isNotEmpty).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: tipsList.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value.trim();

            return Padding(
              padding: EdgeInsets.only(bottom: index < tipsList.length - 1 ? 16 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentGreen,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}