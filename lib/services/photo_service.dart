import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  final ImagePicker _imagePicker = ImagePicker();

  factory PhotoService() {
    return _instance;
  }

  PhotoService._internal();

  /// Capture a photo using camera
  Future<String?> capturePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (photo != null) {
        return await _savePhotoLocally(File(photo.path));
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
    return null;
  }

  /// Pick a photo from gallery
  Future<String?> pickPhotoFromGallery() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (photo != null) {
        return await _savePhotoLocally(File(photo.path));
      }
    } catch (e) {
      debugPrint('Error picking photo: $e');
    }
    return null;
  }

  /// Save photo to local storage
  Future<String> _savePhotoLocally(File photoFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/fitness_genius/photos');
      
      if (!photoDir.existsSync()) {
        photoDir.createSync(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'progress_$timestamp.jpg';
      final savedPhoto = await photoFile.copy(
        '${photoDir.path}/$fileName',
      );

      return savedPhoto.path;
    } catch (e) {
      debugPrint('Error saving photo: $e');
      rethrow;
    }
  }

  /// Delete a photo from storage
  Future<void> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting photo: $e');
    }
  }

  /// Get all progress photos
  Future<List<File>> getAllProgressPhotos() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/fitness_genius/photos');
      
      if (!photoDir.existsSync()) {
        return [];
      }

      final files = photoDir.listSync();
      return files
          .whereType<File>()
          .where((file) => file.path.endsWith('.jpg'))
          .toList()
          ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    } catch (e) {
      debugPrint('Error getting progress photos: $e');
      return [];
    }
  }

  /// Get photos within a date range
  Future<List<File>> getPhotosByDateRange(DateTime start, DateTime end) async {
    try {
      final allPhotos = await getAllProgressPhotos();
      return allPhotos.where((file) {
        final modified = file.statSync().modified;
        return modified.isAfter(start) && modified.isBefore(end);
      }).toList();
    } catch (e) {
      debugPrint('Error getting photos by date range: $e');
      return [];
    }
  }

  /// Check if photos exist for a specific date
  Future<bool> hasPhotoForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final photos = await getPhotosByDateRange(startOfDay, endOfDay);
      return photos.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking photos for date: $e');
      return false;
    }
  }

  /// Get latest progress photos (for comparison)
  Future<List<File>> getLatestProgressPhotos({int limit = 4}) async {
    try {
      final photos = await getAllProgressPhotos();
      return photos.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting latest progress photos: $e');
      return [];
    }
  }

  /// Calculate total storage used by photos
  Future<int> getPhotoStorageUsed() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/fitness_genius/photos');
      
      if (!photoDir.existsSync()) {
        return 0;
      }

      int totalBytes = 0;
      final files = photoDir.listSync();
      for (var file in files.whereType<File>()) {
        totalBytes += file.lengthSync();
      }
      return totalBytes;
    } catch (e) {
      debugPrint('Error calculating photo storage: $e');
      return 0;
    }
  }

  /// Clear all photos (caution!)
  Future<void> clearAllPhotos() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/fitness_genius/photos');
      
      if (photoDir.existsSync()) {
        photoDir.deleteSync(recursive: true);
      }
    } catch (e) {
      debugPrint('Error clearing photos: $e');
    }
  }
}