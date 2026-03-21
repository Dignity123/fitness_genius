import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class IntensitySlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const IntensitySlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  String _getIntensityLabel() {
    if (value < 0.33) {
      return 'LIGHT';
    } else if (value < 0.66) {
      return 'MODERATE';
    } else {
      return 'INTENSE';
    }
  }

  Color _getIntensityColor() {
    if (value < 0.33) {
      return AppTheme.infoBlue;
    } else if (value < 0.66) {
      return AppTheme.warningOrange;
    } else {
      return AppTheme.errorRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TARGET INTENSITY',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getIntensityLabel(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: _getIntensityColor(),
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getIntensityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _getIntensityColor()),
                  ),
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getIntensityColor(),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: value,
              onChanged: onChanged,
              min: 0,
              max: 1,
              activeColor: _getIntensityColor(),
              inactiveColor: AppTheme.borderColor,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIntensityLabel(context, 'Light', 0, 0.33),
                _buildIntensityLabel(context, 'Moderate', 0.33, 0.66),
                _buildIntensityLabel(context, 'Intense', 0.66, 1.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityLabel(
    BuildContext context,
    String label,
    double minVal,
    double maxVal,
  ) {
    final isInRange = value >= minVal && value <= maxVal;
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isInRange ? AppTheme.accentGreen : AppTheme.textSecondary,
            fontWeight: isInRange ? FontWeight.bold : FontWeight.normal,
          ),
    );
  }
}