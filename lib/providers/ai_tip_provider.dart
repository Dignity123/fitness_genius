// lib/providers/ai_tip_provider.dart
import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AITipProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  
  String _currentTip = '';
  List<String> _tips = [];
  bool _isLoading = false;
  String? _error;

  String get currentTip => _currentTip;
  List<String> get tips => _tips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTip() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentTip = await _getPersonalizedTip();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading tip: $e');
      _currentTip = _getFallbackTip();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _getPersonalizedTip() async {
    final allTips = [
      'Consistency beats intensity. Aim for 3-4 workouts per week to see real progress.',
      'Rest days are crucial for muscle recovery and growth. Listen to your body!',
      'Track your progress with photos - visual changes often take longer than scale changes.',
      'Progressive overload: gradually increase weight or reps to keep making gains.',
      'Stay hydrated! Drink water before, during, and after your workouts.',
      'Proper form is more important than heavy weights. Quality over quantity!',
      'Don\'t skip warm-ups. 5-10 minutes of light cardio prevents injury.',
      'Set specific, measurable goals. "Get stronger" vs "Bench press 100kg by next month".',
      'Nutrition is 70% of results. You can\'t out-train a bad diet.',
      'Sleep is when your muscles grow. Aim for 7-9 hours of quality sleep.',
    ];
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return allTips[dayOfYear % allTips.length];
  }

  String _getFallbackTip() {
    return 'Stay consistent and trust the process! Every workout brings you closer to your goals. 💪';
  }

  Future<void> refreshTip() async {
    await loadTip();
  }
}