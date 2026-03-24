# Fitness Genius 💪

## Overview

**Fitness Genius** is an AI-powered Flutter mobile application that helps users track workouts, manage fitness quests, monitor progress, and receive personalized AI-driven workout recommendations. The app features a dark tactical theme with acid green accents, glassmorphic card designs, and 100% local storage for privacy and offline capability.

**Status:** Production Ready ✅  
**Platform:** iOS & Android  
**Framework:** Flutter 3.0+ / Dart 3.0+

---

## Team Members
### Dignity Okorie
- Roles were screens, UI, services, widgets and testing.
### Hushen Huang
- Roles were database, models, services and providers

---


## Key Features

### 🏠 **Home Screen - Dashboard**
- Welcome banner with personalized greeting
- Quick stats: Level, XP, Streak
- Active quests display
- Daily fitness tips
- Glassmorphic card design

### 📚 **Exercise Library**
- 100+ predefined exercises
- Search functionality
- Filter by difficulty (Beginner, Intermediate, Advanced)
- Filter by category (Cardio, Strength, Flexibility, Balance)
- Detailed exercise information with technique tips
- Favorite exercises marking

### 🏃 **Workout Tracker**
- Real-time timer with duration tracking
- Quick start for common workouts:
  - Running
  - Cycling
  - Swimming
  - Gym
- Pause and Finish buttons
- Auto-calculates calories burned (~8 cal/min)
- Saves completed workouts to database
- Shows active workout stats

### 📊 **Progress Tracking**
- Body metrics tracking:
  - Weight
  - Body Fat %
  - Chest, Waist, Hips, Arms circumference
- Weekly progress summary
- Weekly changes comparison
- Progress photo capture via camera
- Manual date selection for flexible data entry
- Weekly summary cards with trend analysis

### 📈 **Workout History**
- Complete workout log with dates
- Completion status badges
- Duration, exercises, and calories per workout
- Sortable and filterable history

### ⚙️ **Settings & Preferences**
- **App Settings:**
  - Notifications toggle
  - Sound effects toggle
  - Vibration/haptic feedback
- **Workout Settings:**
  - Default difficulty selector
  - Rest timer customization
- **About Section:**
  - App version info
  - Privacy policy link

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | Provider |
| **Local Database** | SQLite (sqflite) |
| **Preferences** | SharedPreferences |
| **Media** | image_picker (camera) |
| **UI Design** | Material Design + Glassmorphism |
| **Theme** | Dark with acid green (#B8FF00) accents |
| **Fonts** | System defaults (Roboto/SF Pro) |
| **Storage** | 100% Local (No cloud) |

---

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── theme/
│   └── app_theme.dart                 # Dark theme configuration
├── models/                             # Data models
│   ├── exercise.dart
│   ├── workout_session.dart
│   ├── progress_entry.dart
│   ├── quest.dart
│   ├── user_profile.dart
│   └── workout_set.dart
├── database/                           # SQLite DAOs & helpers
│   ├── database_helper.dart
│   ├── exercise_dao.dart
│   ├── progress_dao.dart
│   ├── quest_dao.dart
│   ├── workout_dao.dart
│   ├── user_dao.dart
│   ├── reward_dao.dart
│   ├── migration_helper.dart
│   └── seed_data.dart
├── providers/                          # State management
│   ├── exercise_provider.dart
│   ├── progress_provider.dart
│   ├── quest_provider.dart
│   ├── workout_provider.dart
│   ├── user_profile_provider.dart
│   └── ai_tip_provider.dart
├── services/                           # Business logic
│   ├── ai_service.dart
│   ├── photo_service.dart
│   ├── notification_service.dart
│   └── preferences_service.dart
├── screens/                            # UI screens
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── library/
│   │   ├── library_screen.dart
│   │   ├── exercise_details_screen.dart
│   │   └── widgets/
│   ├── tracker/
│   │   ├── tracker_screen.dart
│   │   ├── workout_detail_screen.dart
│   │   ├── exercise_log_screen.dart
│   │   └── widgets/
│   ├── progress/
│   │   ├── progress_screen.dart
│   │   └── widgets/
│   ├── history/
│   │   └── workout_history_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── ai_remix/
│   │   ├── ai_remix_screen.dart
│   │   └── widgets/
│   └── exercise/
│       └── exercise_details_screen.dart
├── widgets/                            # Reusable widgets
│   └── glassmorphic_card.dart
├── navigation/
│   └── bottom_nav.dart                # 6-tab navigation
└── utils/                              # Helpers & constants
    ├── constants.dart
    ├── date_utils.dart
    └── validators.dart
```

---

## Database Schema

### SQLite Tables

**exercises**
- id (primary key)
- name
- description
- difficulty
- category
- muscleGroups
- caloriesPerMinute
- technique
- sets, reps, weight

**workout_sessions**
- id (primary key)
- questId (foreign key)
- name
- startTime
- endTime
- isCompleted
- totalCalories
- totalDuration

**exercise_logs**
- id (primary key)
- workoutSessionId (foreign key)
- exerciseId (foreign key)
- setsCompleted
- repsPerSet
- weightUsed

**progress_entries**
- id (primary key)
- date
- notes
- recordedAt

**body_metrics**
- id (primary key)
- progressEntryId (foreign key)
- weight
- bodyFatPercentage
- chest, waist, hips, thighs, arms (circumferences)
- recordedAt

**quests**
- id (primary key)
- title
- description
- difficulty
- xpReward
- isCompleted
- createdAt
- completedAt

**rewards**
- id (primary key)
- questId (foreign key)
- xpGained
- badgeEarned

---

## Key Features Explained

### 🤖 AI Workout Recommendations (AI Remix)
The AI service analyzes:
- User's workout history
- Last completed workout type
- Recovery time since last workout
- User's selected difficulty level (from Settings)
- Provides personalized workout suggestions

### 📱 Glassmorphism Design
All cards feature:
- **Frosted glass effect** with backdrop blur (10px)
- **40% semi-transparent backgrounds**
- **Subtle borders** with acid green color (30% opacity)
- **Soft shadows** for depth
- Professional modern appearance

### 💾 Local Storage Strategy

**SQLite (Complex Data):**
- Exercises with detailed info
- Workout sessions and logs
- Progress entries and metrics
- Quests and achievements

**SharedPreferences (Simple Settings):**
- Notifications toggle
- Sound/Vibration settings
- Default difficulty
- Rest timer duration
- Language preference
- Unit preferences (kg/lbs, km/mi)

### 🔄 State Management Flow

```
User Action (UI) 
    ↓
Provider Method Called
    ↓
Database DAO Call (SQLite)
    ↓
Data Retrieved/Saved
    ↓
notifyListeners() triggered
    ↓
Consumer<Provider> rebuilds
    ↓
UI Updated with new data
```

---

## Core Data Flows

### Saving Body Metrics
1. User enters metrics in Progress screen
2. Taps "SAVE BODY METRICS"
3. `_saveMeasurements()` called in progress_screen.dart
4. Calls `saveBodyMeasurements()` in ProgressProvider
5. ProgressDAO inserts data to SQLite
6. `loadProgressEntries()` reloads all data
7. `notifyListeners()` triggers UI rebuild
8. Weekly Summary and Changes recalculate
9. Progress screen displays updated data

### Starting a Workout
1. User taps "Running" in Tracker screen
2. `_startQuickWorkout()` called
3. WorkoutProvider creates new WorkoutSession
4. Timer starts counting up
5. Pause/Finish buttons become available
6. User taps "FINISH"
7. `completeWorkout()` saves session to WorkoutDAO
8. Data persisted to SQLite
9. Workout appears in History tab

### Tracking Progress Photos
1. User taps "TAKE PHOTO" in Progress screen
2. image_picker opens device camera
3. Photo captured and stored locally
4. Success notification shown
5. Photo path saved to progress_entries table

---

## Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.0.0              # State management
  sqflite: ^2.3.0               # SQLite database
  shared_preferences: ^2.2.0    # Settings storage
  path: ^1.8.0                  # Path utilities
  path_provider: ^2.1.0         # App directories
  image_picker: ^1.0.0          # Camera access
  lottie: ^2.4.0                # Animations
  intl: ^0.19.0                 # Date formatting
  uuid: ^4.0.0                  # ID generation
```

---

## How to Run

### Prerequisites
- Flutter 3.0+ installed
- Android SDK / iOS SDK
- A physical device or emulator

### Steps
```bash
# Clone the repository
git clone https://github.com/Dignity123/fitness_genius.git
cd fitness_genius

# Install dependencies
flutter pub get

# Run the app
flutter run

# Or build APK
flutter build apk --release

# Or build iOS
flutter build ios --release
```

---

## Usability Improvements

### Date Selection Enhancement
**Challenge:** Users could only save one record per day, limiting testing and data entry flexibility.

**Solution:** Implemented manual date picker in progress_screen.dart allowing users to:
- Select any date in the past
- Create multiple records per day
- Test weekly progress calculations

**Impact:** Improved flexibility, easier testing, better user experience

---

## Architecture Decisions

### No Authentication
- Direct access to home screen (no login)
- 100% local storage = maximum privacy
- Works completely offline

### Local-Only Storage
- No cloud dependency
- Faster data access
- Complete user privacy
- Works without internet

### Provider Pattern
- Reactive state management
- Easy to test
- Clear separation of concerns
- Scales well

### Glassmorphic Design
- Modern, premium appearance
- Improved visual hierarchy
- Better readability
- Consistent across all screens

---


## Screenshots
### Home Screen
![Home Screen](assets\screenshots\home_screen.png)

### Exercise Library
![Exercise Library Screen](assets\screenshots\exercise_library_screen.png)

### Tracker Screen
![Tracker Screen](assets\screenshots\tracker_screen.png)

### Progress Screen
![Progress Screen](assets\screenshots\progress_screen.png)

### Workout History Screen 
![Workout History Screen](assets\screenshots\workout_history_screen.png)

### Settings Screen
![Settings Screen](assets\screenshots\settings_screen.png)

---


## Known Limitations & Future Improvements

### Current Limitations
1. No cloud backup (intentional for privacy)
2. No user authentication (intentional)
3. No social features yet
4. Basic AI recommendations (logic-based, not ML)

### Future Enhancements
1. **Cloud Sync:** Optional backup to Firebase
2. **Social Features:** Share achievements, friend comparisons
3. **Advanced Analytics:** ML-based recommendations
4. **Wearable Integration:** Apple Watch, Wear OS
5. **Apple HealthKit & Google Fit:** Integration for health data
6. **Push Notifications:** Workout reminders and tips
7. **Export Data:** PDF reports and CSV exports

---

## Testing & Quality

### How to Run Tests
```bash
flutter test

# Run specific test file
flutter test test/providers/workout_provider_test.dart

# Run with coverage
flutter test --coverage
```

---


## Most Fragile Areas & Refactor Plan

### Fragile Area: Progress Feature
The flow between progress_screen.dart → progress_provider.dart → database is fragile due to:
- Multiple features added incrementally (date selection, weekly summary, weekly changes)
- Complex state updates
- Multiple database calls

### Refactor Plan
1. **Extract calculation logic** into separate utility class
2. **Separate concerns:**
   - Data loading
   - Calculation logic
   - UI updates
3. **Add unit tests** for calculations
4. **Implement caching** to reduce database calls
5. **Use immutable data** models with copyWith()
6. **Monitor for side effects** in provider

### Verification Strategy
- Run existing test suite
- Manual testing on all progress features
- Performance profiling
- Edge case testing (no data, single entry, multiple entries)
 

---

## Contact & Support

**Project Lead:** Dignity123  
**Repository:** https://github.com/Dignity123/fitness_genius  
**Version:** 1.0.0  
**Last Updated:** March 2026

---

## License

This project is open source and available under the MIT License.

---

## Acknowledgments

Built with ❤️ using Flutter and Dart.  
Inspired by modern fitness tracking applications and glassmorphic design trends.

**Special Thanks To:**
- Flutter community for amazing documentation
- Provider package maintainers

---

**Ready to transform your fitness journey? Download Fitness Genius today! 💪🔥**