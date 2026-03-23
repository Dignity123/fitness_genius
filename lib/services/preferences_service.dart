import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  late SharedPreferences _prefs;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  // Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('✅ PreferencesService initialized');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
    debugPrint('💬 Notifications: $enabled');
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME & DISPLAY SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setDarkModeEnabled(bool enabled) async {
    await _prefs.setBool('dark_mode', enabled);
    debugPrint('🌙 Dark Mode: $enabled');
  }

  bool getDarkModeEnabled() {
    return _prefs.getBool('dark_mode') ?? true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WORKOUT SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setDefaultDifficulty(String difficulty) async {
    await _prefs.setString('default_difficulty', difficulty);
    debugPrint('💪 Default Difficulty: $difficulty');
  }

  String getDefaultDifficulty() {
    return _prefs.getString('default_difficulty') ?? 'Intermediate';
  }

  Future<void> setDefaultRestTimer(int seconds) async {
    await _prefs.setInt('default_rest_timer', seconds);
    debugPrint('⏱️ Rest Timer: ${seconds}s');
  }

  int getDefaultRestTimer() {
    return _prefs.getInt('default_rest_timer') ?? 60;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SOUND & VIBRATION
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool('sound_enabled', enabled);
    debugPrint('🔊 Sound: $enabled');
  }

  bool getSoundEnabled() {
    return _prefs.getBool('sound_enabled') ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs.setBool('vibration_enabled', enabled);
    debugPrint('📳 Vibration: $enabled');
  }

  bool getVibrationEnabled() {
    return _prefs.getBool('vibration_enabled') ?? true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LANGUAGE & LOCALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
    debugPrint('🌐 Language: $language');
  }

  String getLanguage() {
    return _prefs.getString('language') ?? 'en';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTO-START & QUICK ACCESS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setAutoStartWorkout(bool enabled) async {
    await _prefs.setBool('auto_start_workout', enabled);
    debugPrint('▶️ Auto-start: $enabled');
  }

  bool getAutoStartWorkout() {
    return _prefs.getBool('auto_start_workout') ?? false;
  }

  Future<void> setLastActiveTab(int tabIndex) async {
    await _prefs.setInt('last_active_tab', tabIndex);
  }

  int getLastActiveTab() {
    return _prefs.getInt('last_active_tab') ?? 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UNIT PREFERENCES
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setWeightUnit(String unit) async {
    // 'kg' or 'lbs'
    await _prefs.setString('weight_unit', unit);
    debugPrint('⚖️ Weight Unit: $unit');
  }

  String getWeightUnit() {
    return _prefs.getString('weight_unit') ?? 'kg';
  }

  Future<void> setDistanceUnit(String unit) async {
    // 'km' or 'mi'
    await _prefs.setString('distance_unit', unit);
    debugPrint('📏 Distance Unit: $unit');
  }

  String getDistanceUnit() {
    return _prefs.getString('distance_unit') ?? 'km';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVACY & DATA
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool('analytics_enabled', enabled);
    debugPrint('📊 Analytics: $enabled');
  }

  bool getAnalyticsEnabled() {
    return _prefs.getBool('analytics_enabled') ?? false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR ALL PREFERENCES
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> clearAllPreferences() async {
    await _prefs.clear();
    debugPrint('🗑️ All preferences cleared');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DEBUG - GET ALL PREFERENCES
  // ═══════════════════════════════════════════════════════════════════════════

  void debugPrintAllPreferences() {
    debugPrint('📋 All Saved Preferences:');
    _prefs.getKeys().forEach((key) {
      final value = _prefs.get(key);
      debugPrint('  $key: $value');
    });
  }
}