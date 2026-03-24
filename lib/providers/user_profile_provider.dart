// lib/providers/user_profile_provider.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../database/user_dao.dart'; // We need to create this DAO

class UserProfileProvider extends ChangeNotifier {
  final UserDAO _userDAO = UserDAO();
  
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _userProfile != null;

  // Load user profile (there should only be one)
  Future<void> loadUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userProfile = await _userDAO.getUserProfile();
      
      // If no user exists, create a default one
      if (_userProfile == null) {
        _userProfile = await _userDAO.createDefaultUser();
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      await _userDAO.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating user profile: $e');
      notifyListeners();
    }
  }

  // Add XP and check for level up
  Future<void> addXP(int xp) async {
    if (_userProfile == null) return;
    
    try {
      final newTotalXP = _userProfile!.totalXP + xp;
      final oldLevel = _userProfile!.currentLevel;
      final newLevel = (newTotalXP / 1000).floor() + 1;
      
      final updatedProfile = _userProfile!.copyWith(
        totalXP: newTotalXP,
        currentLevel: newLevel,
      );
      
      await _userDAO.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      
      // Check for level up
      if (newLevel > oldLevel) {
        _error = null;
        notifyListeners();
        // Level up event could be handled here
      } else {
        notifyListeners();
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding XP: $e');
      notifyListeners();
    }
  }

  // Update streak after workout
  Future<void> updateStreak() async {
    if (_userProfile == null) return;
    
    try {
      final now = DateTime.now();
      final lastWorkout = _userProfile!.lastWorkoutDate;
      final daysSinceLastWorkout = now.difference(lastWorkout).inDays;
      
      int newStreak = _userProfile!.currentStreak;
      int newLongestStreak = _userProfile!.longestStreak;
      
      if (daysSinceLastWorkout == 1) {
        // Consecutive day - increase streak
        newStreak++;
        if (newStreak > newLongestStreak) {
          newLongestStreak = newStreak;
        }
      } else if (daysSinceLastWorkout > 1) {
        // Streak broken
        newStreak = 1;
      }
      // If same day, don't change streak
      
      final updatedProfile = _userProfile!.copyWith(
        currentStreak: newStreak,
        longestStreak: newLongestStreak,
        lastWorkoutDate: now,
      );
      
      await _userDAO.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating streak: $e');
      notifyListeners();
    }
  }

  // Unlock a badge
  Future<void> unlockBadge(String badge) async {
    if (_userProfile == null) return;
    
    try {
      if (!_userProfile!.unlockedBadges.contains(badge)) {
        final updatedBadges = [..._userProfile!.unlockedBadges, badge];
        final updatedProfile = _userProfile!.copyWith(
          unlockedBadges: updatedBadges,
        );
        
        await _userDAO.updateUserProfile(updatedProfile);
        _userProfile = updatedProfile;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error unlocking badge: $e');
      notifyListeners();
    }
  }

  // Update preferences
  Future<void> updatePreferences(Map<String, dynamic> newPreferences) async {
    if (_userProfile == null) return;
    
    try {
      final updatedPreferences = {..._userProfile!.preferences, ...newPreferences};
      final updatedProfile = _userProfile!.copyWith(
        preferences: updatedPreferences,
      );
      
      await _userDAO.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating preferences: $e');
      notifyListeners();
    }
  }

  // Reset all user data (for testing)
  Future<void> resetUserData() async {
    try {
      await _userDAO.deleteAllUsers();
      await loadUserProfile();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error resetting user data: $e');
      notifyListeners();
    }
  }
}