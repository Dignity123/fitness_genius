import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  int get currentStreak => _userProfile?.currentStreak ?? 0;
  int get totalXP => _userProfile?.totalXP ?? 0;
  int get currentLevel => _userProfile?.currentLevel ?? 1;

  Future<void> initializeUser(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = UserProfile(name: name);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error initializing user: $e');
      notifyListeners();
    }
  }

  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void addXP(int xp) {
    if (_userProfile == null) return;
    final newXP = _userProfile!.totalXP + xp;
    final newLevel = (newXP ~/ 1000) + 1;
    
    _userProfile = _userProfile!.copyWith(
      totalXP: newXP,
      currentLevel: newLevel,
    );
    notifyListeners();
  }

  void updateStreak(int days) {
    if (_userProfile == null) return;
    
    final newLongest = days > _userProfile!.longestStreak ? days : _userProfile!.longestStreak;
    
    _userProfile = _userProfile!.copyWith(
      currentStreak: days,
      longestStreak: newLongest,
      lastWorkoutDate: DateTime.now(),
    );
    notifyListeners();
  }

  void resetStreak() {
    if (_userProfile == null) return;
    _userProfile = _userProfile!.copyWith(currentStreak: 0);
    notifyListeners();
  }

  void unlockBadge(String badge) {
    if (_userProfile == null) return;
    
    if (!_userProfile!.unlockedBadges.contains(badge)) {
      _userProfile = _userProfile!.copyWith(
        unlockedBadges: [..._userProfile!.unlockedBadges, badge],
      );
      notifyListeners();
    }
  }
}