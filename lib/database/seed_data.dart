import '../models/exercise.dart';

class SeedData {
  static List<Exercise> getInitialExercises() {
    return [
      Exercise(
        name: 'Bench Press',
        description: 'Classic chest exercise that builds upper body strength and mass',
        category: 'strength',
        difficulty: 'intermediate',
        equipment: 'Barbell, Bench',
        muscleGroups: ['chest', 'shoulders', 'triceps'],
        sets: 3,
        reps: 10,
        technique: 'Keep feet flat on ground|Arch your back slightly|Lower bar to mid-chest|Push through your heels|Keep elbows at 45 degrees|Squeeze chest at the top',
      ),
      Exercise(
        name: 'Push-ups',
        description: 'Bodyweight exercise for chest, shoulders, and triceps',
        category: 'strength',
        difficulty: 'beginner',
        equipment: null,
        muscleGroups: ['chest', 'shoulders', 'triceps', 'core'],
        sets: 3,
        reps: 15,
        technique: 'Keep body in straight line|Hands shoulder-width apart|Lower chest to ground|Keep elbows close to body|Engage core throughout|Breathe in on way down, out on way up',
      ),
      Exercise(
        name: 'Squat',
        description: 'Compound leg exercise for overall lower body strength',
        category: 'strength',
        difficulty: 'intermediate',
        equipment: 'Barbell, Squat rack',
        muscleGroups: ['legs', 'glutes', 'core'],
        sets: 3,
        reps: 8,
        technique: 'Keep chest up|Push hips back|Knees track over toes|Go to parallel or below|Drive through heels|Keep back straight',
      ),
      Exercise(
        name: 'Pull-up',
        description: 'Upper back and bicep strengthening exercise',
        category: 'strength',
        difficulty: 'advanced',
        equipment: 'Pull-up bar',
        muscleGroups: ['back', 'biceps', 'shoulders'],
        sets: 3,
        reps: 8,
        technique: 'Start from dead hang|Pull chest to bar|Squeeze shoulder blades|Control the descent|Avoid swinging|Engage lats',
      ),
      Exercise(
        name: 'Deadlift',
        description: 'Full body compound movement for posterior chain strength',
        category: 'strength',
        difficulty: 'advanced',
        equipment: 'Barbell',
        muscleGroups: ['back', 'legs', 'glutes', 'core'],
        sets: 3,
        reps: 5,
        technique: 'Bar over mid-foot|Bend at hips, not lower back|Keep back flat|Drive through heels|Keep bar close to body|Lock out hips at top',
      ),
      Exercise(
        name: 'Plank',
        description: 'Core stability exercise',
        category: 'strength',
        difficulty: 'beginner',
        equipment: null,
        muscleGroups: ['core', 'shoulders'],
        sets: 3,
        reps: 1,
        technique: 'Elbows under shoulders|Keep body in straight line|Squeeze glutes and abs|Don\'t let hips sag|Breathe steadily|Hold for time',
      ),
      Exercise(
        name: 'Running',
        description: 'Cardiovascular endurance training',
        category: 'cardio',
        difficulty: 'beginner',
        equipment: 'Running shoes',
        muscleGroups: ['legs', 'cardio'],
        sets: 1,
        reps: 1,
        technique: 'Land mid-foot|Keep cadence high|Maintain upright posture|Relax shoulders|Breathe rhythmically|Warm up before, cool down after',
      ),
      Exercise(
        name: 'Shoulder Press',
        description: 'Overhead pressing for shoulder development',
        category: 'strength',
        difficulty: 'intermediate',
        equipment: 'Dumbbells or Barbell',
        muscleGroups: ['shoulders', 'triceps'],
        sets: 3,
        reps: 10,
        technique: 'Keep core tight|Don\'t arch back excessively|Press directly overhead|Lower with control|Keep wrists straight|Breathe out on exertion',
      ),
    ];
  }

  static List<Reward> getInitialRewards() {
    return [
      Reward(
        name: 'First Workout',
        xpPoints: 50,
        badge: '🏆',
      ),
      Reward(
        name: '7-Day Streak',
        xpPoints: 100,
        badge: '🔥',
      ),
      Reward(
        name: '30-Day Streak',
        xpPoints: 500,
        badge: '⚡',
      ),
      Reward(
        name: '100 Workouts',
        xpPoints: 1000,
        badge: '💪',
      ),
      Reward(
        name: 'Level 10',
        xpPoints: 200,
        badge: '⭐',
      ),
    ];
  }
}