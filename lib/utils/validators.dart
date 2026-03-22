class Validators {
  static String? validateQuestTitle(String? value) {
    if (value?.isEmpty ?? true) return 'Quest title cannot be empty';
    if (value!.length < 3) return 'Title must be at least 3 characters';
    if (value.length > 100) return 'Title cannot exceed 100 characters';
    return null;
  }

  static String? validateDescription(String? value) {
    if (value?.isEmpty ?? true) return 'Description cannot be empty';
    if (value!.length < 10) return 'Description must be at least 10 characters';
    if (value.length > 500) return 'Description cannot exceed 500 characters';
    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value?.isEmpty ?? true) return '$fieldName cannot be empty';
    final number = int.tryParse(value!);
    if (number == null) return '$fieldName must be a number';
    if (number <= 0) return '$fieldName must be greater than 0';
    return null;
  }

  static String? validateExerciseName(String? value) {
    if (value?.isEmpty ?? true) return 'Exercise name cannot be empty';
    if (value!.length < 2) return 'Name must be at least 2 characters';
    if (value.length > 100) return 'Name cannot exceed 100 characters';
    return null;
  }

  static String? validateUsername(String? value) {
    if (value?.isEmpty ?? true) return 'Username cannot be empty';
    if (value!.length < 3) return 'Username must be at least 3 characters';
    if (value.length > 30) return 'Username cannot exceed 30 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return null; // Optional field
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value?.isEmpty ?? true) return 'Weight cannot be empty';
    final weight = double.tryParse(value!);
    if (weight == null) return 'Weight must be a number';
    if (weight <= 0) return 'Weight must be greater than 0';
    if (weight > 500) return 'Weight seems too high';
    return null;
  }

  static String? validateMeasurement(String? value) {
    if (value?.isEmpty ?? true) return 'Measurement cannot be empty';
    final measurement = double.tryParse(value!);
    if (measurement == null) return 'Measurement must be a number';
    if (measurement <= 0) return 'Measurement must be greater than 0';
    return null;
  }
}