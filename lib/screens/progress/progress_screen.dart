import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/glassmorphic_card.dart';
import 'widgets/weekly_progress_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _thighsController = TextEditingController();
  final _armsController = TextEditingController();
  final _notesController = TextEditingController();

  bool _didInitialLoad = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProgressProvider>().loadProgressEntries();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _thighsController.dispose();
    _armsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _fillControllersOnce(ProgressProvider provider) {
    if (_didInitialLoad) return;

    final metrics = provider.latestMetrics;
    _weightController.text = metrics?.weight?.toString() ?? '';
    _bodyFatController.text = metrics?.bodyFatPercentage?.toString() ?? '';
    _chestController.text = metrics?.chest?.toString() ?? '';
    _waistController.text = metrics?.waist?.toString() ?? '';
    _hipsController.text = metrics?.hips?.toString() ?? '';
    _thighsController.text = metrics?.thighs?.toString() ?? '';
    _armsController.text = metrics?.arms?.toString() ?? '';
    _notesController.text = metrics?.notes ?? '';

    _didInitialLoad = true;
  }

  double? _parseNumber(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo captured: ${photo.name}'),
            backgroundColor: AppTheme.accentGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _saveMeasurements() async {
    final provider = context.read<ProgressProvider>();

    try {
      await provider.saveBodyMeasurements(
        selectedDate: _selectedDate,
        weight: _parseNumber(_weightController.text),
        bodyFatPercentage: _parseNumber(_bodyFatController.text),
        chest: _parseNumber(_chestController.text),
        waist: _parseNumber(_waistController.text),
        hips: _parseNumber(_hipsController.text),
        thighs: _parseNumber(_thighsController.text),
        arms: _parseNumber(_armsController.text),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Body metrics saved for ${_formatDate(_selectedDate)}.',
          ),
          backgroundColor: AppTheme.accentGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      setState(() {
        _didInitialLoad = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save body metrics: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        _fillControllersOnce(progressProvider);

        final latestMetrics = progressProvider.latestMetrics;
        final weeklySummary = progressProvider.getWeeklySummary();
        final weeklyComparisonRaw = progressProvider.getWeeklyComparison();
        final last7Days = progressProvider.getLast7DaysEntries();

        final weeklyChanges = <String, String>{
          'Weight': weeklySummary['weight'] ?? '--',
          'Body Fat': weeklySummary['bodyFat'] ?? '--',
          'Chest': weeklySummary['chest'] ?? '--',
          'Waist': weeklySummary['waist'] ?? '--',
          'Hips': weeklySummary['hips'] ?? '--',
          'Thighs': weeklySummary['thighs'] ?? '--',
          'Arms': weeklySummary['arms'] ?? '--',
        };

        return Scaffold(
          appBar: AppBar(
            title: const Text('PROGRESS'),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/placeholder4.jpg',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.1),
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppTheme.primaryDark);
                  },
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassmorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR PROGRESS',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 1,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildProgressStat(
                                'Weight',
                                latestMetrics?.weight != null
                                    ? '${latestMetrics!.weight!.toStringAsFixed(1)}'
                                    : '--',
                                context,
                              ),
                              _buildProgressStat(
                                'Body Fat',
                                latestMetrics?.bodyFatPercentage != null
                                    ? '${latestMetrics!.bodyFatPercentage!.toStringAsFixed(1)}%'
                                    : '--',
                                context,
                              ),
                              _buildProgressStat(
                                'Entries',
                                '${progressProvider.entries.length}',
                                context,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    WeeklyProgressCard(
                      title: 'This Week Summary',
                      values: {
                        'Entries': weeklySummary['entries'] ?? '0',
                        'Tracked Days': '${last7Days.length}',
                        'Start vs Latest':
                            weeklyComparisonRaw.isEmpty ? '--' : 'Active',
                        'Status': last7Days.isEmpty ? 'No data' : 'Tracking',
                      },
                    ),
                    const SizedBox(height: 16),
                    WeeklyProgressCard(
                      title: 'Weekly Changes',
                      values: weeklyChanges,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'LAST 7 DAYS RECORDS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (last7Days.isEmpty)
                      GlassmorphicCard(
                        child: Text(
                          'No weekly records yet. Save your body metrics to start tracking weekly progress.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      )
                    else
                      ...last7Days.map((entry) {
                        final m = entry.metrics;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassmorphicCard(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDate(entry.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppTheme.accentGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    _buildMiniMetric('Weight', m?.weight, 'kg'),
                                    _buildMiniMetric('Body Fat', m?.bodyFatPercentage, '%'),
                                    _buildMiniMetric('Chest', m?.chest, 'cm'),
                                    _buildMiniMetric('Waist', m?.waist, 'cm'),
                                    _buildMiniMetric('Hips', m?.hips, 'cm'),
                                    _buildMiniMetric('Thighs', m?.thighs, 'cm'),
                                    _buildMiniMetric('Arms', m?.arms, 'cm'),
                                  ],
                                ),
                                if (m?.notes != null && m!.notes!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Notes: ${m.notes!}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppTheme.textSecondary),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 24),
                    Text(
                      'PROGRESS PHOTOS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    GlassmorphicCard(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: AppTheme.accentGreen,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Add Progress Photo',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('TAKE PHOTO'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'BODY METRICS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    GlassmorphicCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Date',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          TextButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_month),
                            label: Text(_formatDate(_selectedDate)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Weight',
                      controller: _weightController,
                      currentValue: latestMetrics?.weight,
                      suffixText: 'kg',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Body Fat',
                      controller: _bodyFatController,
                      currentValue: latestMetrics?.bodyFatPercentage,
                      suffixText: '%',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Chest',
                      controller: _chestController,
                      currentValue: latestMetrics?.chest,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Waist',
                      controller: _waistController,
                      currentValue: latestMetrics?.waist,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Hips',
                      controller: _hipsController,
                      currentValue: latestMetrics?.hips,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Thighs',
                      controller: _thighsController,
                      currentValue: latestMetrics?.thighs,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 12),
                    _buildMetricEditor(
                      label: 'Arms',
                      controller: _armsController,
                      currentValue: latestMetrics?.arms,
                      suffixText: 'cm',
                    ),
                    const SizedBox(height: 12),
                    GlassmorphicCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Add notes...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            progressProvider.isLoading ? null : _saveMeasurements,
                        icon: const Icon(Icons.save),
                        label: Text(
                          progressProvider.isLoading
                              ? 'SAVING...'
                              : 'SAVE BODY METRICS',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressStat(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentGreen,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildMiniMetric(String label, double? value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: AppTheme.accentGreen.withOpacity(0.18)),
      ),
      child: Text(
        value == null ? '$label: --' : '$label: ${value.toStringAsFixed(1)} $unit',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildMetricEditor({
    required String label,
    required TextEditingController controller,
    required double? currentValue,
    required String suffixText,
  }) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                currentValue == null
                    ? 'No data'
                    : '${currentValue.toStringAsFixed(1)} $suffixText',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              suffixText: suffixText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
