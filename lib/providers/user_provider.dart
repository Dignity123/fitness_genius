import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../database/user_dao.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  final UserDAO _userDAO = UserDAO();

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  int get currentStreak => _userProfile?.currentStreak ?? 0;
  int get totalXP => _userProfile?.totalXP ?? 0;
  int get currentLevel => _userProfile?.currentLevel ?? 1;

  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Demo login - in production, verify against backend
      if (email == 'demo@fitnessgeniusapp.com' && password == 'demo123456') {
        _userProfile = UserProfile(
          id: '1',
          name: 'Demo User',
          email: email,
        );
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      // Try database lookup
      // This would be uncommented for production with proper authentication
      // final user = await _userDAO.getUserByEmail(email);
      // if (user != null && user.password == password) { // In production: hash verification
      //   _userProfile = user;
      //   _isLoggedIn = true;
      //   _isLoading = false;
      //   notifyListeners();
      //   return true;
      // }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      debugPrint('Login error: $e');
      notifyListeners();
      return false;
    }
  }

  // Register method
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );

      // In production: save to backend with hashed password
      // await _userDAO.insertUser(newUser);
      
      _userProfile = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      debugPrint('Register error: $e');
      notifyListeners();
      return false;
    }
  }

  // Logout method
  void logout() {
    _userProfile = null;
    _isLoggedIn = false;
    notifyListeners();
  }

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