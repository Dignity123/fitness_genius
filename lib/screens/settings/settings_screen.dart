import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/preferences_service.dart';
import '../../widgets/glassmorphic_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late PreferencesService _prefsService;
  late bool _notificationsEnabled;
  late String _selectedDifficulty;
  late int _restTimer;
  late bool _soundEnabled;
  late bool _vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _prefsService = PreferencesService();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      _notificationsEnabled = _prefsService.getNotificationsEnabled();
      _selectedDifficulty = _prefsService.getDefaultDifficulty();
      _restTimer = _prefsService.getDefaultRestTimer();
      _soundEnabled = _prefsService.getSoundEnabled();
      _vibrationEnabled = _prefsService.getVibrationEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholder6.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.1),
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppTheme.primaryDark);
              },
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Settings Section
                _buildSectionTitle('APP SETTINGS'),
                const SizedBox(height: 16),

                // Notifications Toggle
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Receive workout reminders',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      await _prefsService.setNotificationsEnabled(value);
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 12),

                // Sound Toggle
                _buildSettingTile(
                  icon: Icons.volume_up_outlined,
                  title: 'Sound Effects',
                  subtitle: 'Enable audio feedback',
                  trailing: Switch(
                    value: _soundEnabled,
                    onChanged: (value) async {
                      await _prefsService.setSoundEnabled(value);
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 12),

                // Vibration Toggle
                _buildSettingTile(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Enable haptic feedback',
                  trailing: Switch(
                    value: _vibrationEnabled,
                    onChanged: (value) async {
                      await _prefsService.setVibrationEnabled(value);
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 24),

                // Workout Settings Section
                _buildSectionTitle('WORKOUT SETTINGS'),
                const SizedBox(height: 16),

                // Difficulty Level
                _buildSettingTile(
                  icon: Icons.trending_up_outlined,
                  title: 'Default Difficulty',
                  subtitle: _selectedDifficulty,
                  onTap: () {
                    _showDifficultyDialog();
                  },
                ),
                const SizedBox(height: 12),

                // Rest Timer
                _buildSettingTile(
                  icon: Icons.timer_outlined,
                  title: 'Default Rest Timer',
                  subtitle: '${_restTimer}s',
                  onTap: () {
                    _showRestTimerDialog();
                  },
                ),
                const SizedBox(height: 24),

                // About Section
                _buildSectionTitle('ABOUT'),
                const SizedBox(height: 16),

                // App Version
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: '1.0.0',
                ),
                const SizedBox(height: 12),

                // Privacy
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                const SizedBox(height: 24),

                // Info Card
                GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fitness Genius',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your AI-powered fitness companion. Track workouts, build streaks, and achieve your goals!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppTheme.accentGreen,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.accentGreen,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: const Text('SELECT DIFFICULTY'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Beginner', 'Intermediate', 'Advanced']
                .map((difficulty) => GestureDetector(
              onTap: () async {
                await _prefsService.setDefaultDifficulty(difficulty);
                setState(() {
                  _selectedDifficulty = difficulty;
                });
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    if (_selectedDifficulty == difficulty)
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.accentGreen,
                      )
                    else
                      Icon(
                        Icons.circle_outlined,
                        color: AppTheme.textSecondary,
                      ),
                    const SizedBox(width: 12),
                    Text(difficulty),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
        );
      },
    );
  }

  void _showRestTimerDialog() {
    final controller = TextEditingController(text: _restTimer.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: const Text('REST TIMER (seconds)'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '60',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                final newValue = int.tryParse(controller.text) ?? 60;
                await _prefsService.setDefaultRestTimer(newValue);
                setState(() {
                  _restTimer = newValue;
                });
                Navigator.pop(context);
              },
              child: const Text('SET'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryDark,
          title: const Text('ABOUT'),
          content: const Text(
            'Fitness Genius v1.0.0\n\n'
            'An AI-powered fitness tracking application built with Flutter.\n\n'
            'Track your workouts, monitor progress, and achieve your fitness goals!\n\n'
            'Local Storage: SQLite (workouts) + SharedPreferences (settings)',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}