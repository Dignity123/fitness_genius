import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class RestTimerWidget extends StatefulWidget {
  final int initialSeconds;

  const RestTimerWidget({
    Key? key,
    this.initialSeconds = 90,
  }) : super(key: key);

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int _remainingSeconds;
  late PageController _pageController;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRunning && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        _startTimer();
      } else if (_remainingSeconds == 0) {
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'REST TIME',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              _formatTime(_remainingSeconds),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.accentGreen,
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'PAUSE' : 'START'),
                  onPressed: _toggleTimer,
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESET'),
                  onPressed: () {
                    setState(() {
                      _remainingSeconds = widget.initialSeconds;
                      _isRunning = false;
                    });
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