import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // Mock notifications - would integrate with flutter_local_notifications in production
  final List<Map<String, dynamic>> _notifications = [];

  /// Schedule a workout reminder
  Future<void> scheduleWorkoutReminder({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // In production, would use flutter_local_notifications
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime,
        'type': 'workout',
      });

      debugPrint('Workout reminder scheduled for ${scheduledTime.toString()}');
    } catch (e) {
      debugPrint('Error scheduling workout reminder: $e');
    }
  }

  /// Schedule a rest day reminder
  Future<void> scheduleRestDayReminder({
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': 'Rest Day',
        'body': body,
        'scheduledTime': scheduledTime,
        'type': 'rest',
      });

      debugPrint('Rest day reminder scheduled for ${scheduledTime.toString()}');
    } catch (e) {
      debugPrint('Error scheduling rest day reminder: $e');
    }
  }

  /// Schedule a streak reminder
  Future<void> scheduleStreakReminder({
    required int currentStreak,
    required DateTime scheduledTime,
  }) async {
    try {
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': 'Keep Your Streak Alive!',
        'body': 'You have a $currentStreak day streak. Complete a workout today!',
        'scheduledTime': scheduledTime,
        'type': 'streak',
      });

      debugPrint('Streak reminder scheduled');
    } catch (e) {
      debugPrint('Error scheduling streak reminder: $e');
    }
  }

  /// Schedule a progress photo reminder
  Future<void> scheduleProgressPhotoReminder({
    required DateTime scheduledTime,
  }) async {
    try {
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': 'Time for Progress Photos',
        'body': 'It\'s been a week! Capture your progress photos to track your transformation.',
        'scheduledTime': scheduledTime,
        'type': 'progress',
      });

      debugPrint('Progress photo reminder scheduled');
    } catch (e) {
      debugPrint('Error scheduling progress photo reminder: $e');
    }
  }

  /// Schedule a metrics reminder
  Future<void> scheduleMetricsReminder({
    required DateTime scheduledTime,
  }) async {
    try {
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': 'Log Your Metrics',
        'body': 'Update your body measurements to track your progress.',
        'scheduledTime': scheduledTime,
        'type': 'metrics',
      });

      debugPrint('Metrics reminder scheduled');
    } catch (e) {
      debugPrint('Error scheduling metrics reminder: $e');
    }
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    try {
      _notifications.removeWhere((notif) => notif['id'] == id);
      debugPrint('Notification cancelled');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      _notifications.clear();
      debugPrint('All notifications cancelled');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }

  /// Get scheduled notifications
  List<Map<String, dynamic>> getScheduledNotifications() {
    return List.from(_notifications);
  }

  /// Setup daily reminder
  Future<void> setupDailyWorkoutReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

      // If time has passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await scheduleWorkoutReminder(
        title: 'Time to Work Out!',
        body: 'Your daily workout is ready. Let\'s hit those goals!',
        scheduledTime: scheduledTime,
      );
    } catch (e) {
      debugPrint('Error setting up daily reminder: $e');
    }
  }

  /// Setup weekly streak check reminder
  Future<void> setupWeeklyStreakReminder({
    required int dayOfWeek, // 1 = Monday, 7 = Sunday
    required int hour,
    required int minute,
  }) async {
    try {
      final now = DateTime.now();
      int daysUntilDay = (dayOfWeek - now.weekday) % 7;
      if (daysUntilDay == 0) daysUntilDay = 7;

      final scheduledTime = now
          .add(Duration(days: daysUntilDay))
          .copyWith(hour: hour, minute: minute, second: 0);

      await scheduleStreakReminder(
        currentStreak: 0,
        scheduledTime: scheduledTime,
      );
    } catch (e) {
      debugPrint('Error setting up weekly reminder: $e');
    }
  }

  /// Show an immediate notification (for testing)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    try {
      _notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': title,
        'body': body,
        'scheduledTime': DateTime.now(),
        'type': 'immediate',
      });

      debugPrint('Notification shown: $title - $body');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}