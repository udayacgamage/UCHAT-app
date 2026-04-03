import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/logger.dart';

/// Media service for image picking, compression, and upload
class MediaService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      AppLogger.info('Picking image from camera');
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e, st) {
      AppLogger.error('Failed to pick image from camera: $e', st);
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      AppLogger.info('Picking image from gallery');
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e, st) {
      AppLogger.error('Failed to pick image from gallery: $e', st);
      return null;
    }
  }

  /// Upload image to Firebase Storage and return download URL with progress stream
  /// Returns a Stream<double> for progress (0.0 to 1.0) and completes with the URL
  Stream<({double progress, String? url})> uploadImageToStorage(
    File imageFile,
    String chatId,
  ) async* {
    try {
      AppLogger.info('Uploading image for chat $chatId');

      final fileName = const Uuid().v4();
      final ref = _storage.ref().child('chats/$chatId/$fileName.jpg');

      final uploadTask = ref.putFile(imageFile);

      // Listen to upload progress
      await for (final event in uploadTask.snapshotEvents) {
        final progress = event.bytesTransferred / event.totalBytes;
        AppLogger.debug('Upload progress: ${(progress * 100).toStringAsFixed(0)}%');
        yield (progress: progress, url: null);
      }

      // Get download URL
      final url = await ref.getDownloadURL();

      AppLogger.success('Image uploaded: $url');
      yield (progress: 1.0, url: url);
    } catch (e, st) {
      AppLogger.error('Image upload failed: $e', st);
      throw AppException(
        message: 'Failed to upload image',
        originalException: e,
      );
    }
  }

  /// Upload profile photo
  Stream<({double progress, String? url})> uploadProfilePhoto(
    File photoFile,
    String userId,
  ) async* {
    try {
      AppLogger.info('Uploading profile photo for $userId');

      final ref = _storage.ref().child('profiles/$userId/avatar.jpg');
      final uploadTask = ref.putFile(photoFile);

      await for (final event in uploadTask.snapshotEvents) {
        final progress = event.bytesTransferred / event.totalBytes;
        yield (progress: progress, url: null);
      }

      final url = await ref.getDownloadURL();

      AppLogger.success('Profile photo uploaded: $url');
      yield (progress: 1.0, url: url);
    } catch (e, st) {
      AppLogger.error('Profile photo upload failed: $e', st);
      throw AppException(
        message: 'Failed to upload profile photo',
        originalException: e,
      );
    }
  }
}

