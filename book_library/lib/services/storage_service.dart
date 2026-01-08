import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Storage Service - handles Firebase Storage operations for book covers
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload book cover image
  /// Returns the download URL of the uploaded image
  Future<String> uploadBookCover({
    required File imageFile,
    required String userId,
    required String bookId,
  }) async {
    try {
      // Create reference for the image
      final ref = _storage
          .ref()
          .child('book_covers')
          .child(userId)
          .child('$bookId.jpg');

      // Upload settings for optimization
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'uploadedAt': DateTime.now().toIso8601String()},
      );

      // Upload file
      final uploadTask = ref.putFile(imageFile, metadata);

      // Monitor upload progress (optional, for debug)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('Upload progress: ${progress.toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw _handleStorageError(e.code);
    } catch (e) {
      throw 'Gagal upload gambar: $e';
    }
  }

  /// Delete book cover image
  Future<void> deleteBookCover({
    required String userId,
    required String bookId,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child('book_covers')
          .child(userId)
          .child('$bookId.jpg');

      await ref.delete();
    } on FirebaseException catch (e) {
      // Ignore if file doesn't exist
      if (e.code == 'object-not-found') {
        debugPrint('Image not found, skipping delete');
        return;
      }
      throw _handleStorageError(e.code);
    } catch (e) {
      throw 'Gagal menghapus gambar: $e';
    }
  }

  /// Delete book cover by URL
  Future<void> deleteBookCoverByUrl(String coverUrl) async {
    if (coverUrl.isEmpty) return;

    try {
      final ref = _storage.refFromURL(coverUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      // Ignore if file doesn't exist
      if (e.code == 'object-not-found') {
        debugPrint('Image not found, skipping delete');
        return;
      }
      throw _handleStorageError(e.code);
    } catch (e) {
      throw 'Gagal menghapus gambar: $e';
    }
  }

  /// Upload image from bytes (for web support in future)
  Future<String> uploadBookCoverBytes({
    required Uint8List imageBytes,
    required String userId,
    required String bookId,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child('book_covers')
          .child(userId)
          .child('$bookId.jpg');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      await ref.putData(imageBytes, metadata);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw _handleStorageError(e.code);
    } catch (e) {
      throw 'Gagal upload gambar: $e';
    }
  }

  /// Handle Storage errors
  String _handleStorageError(String code) {
    switch (code) {
      case 'unauthorized':
        return 'Tidak memiliki izin untuk upload';
      case 'canceled':
        return 'Upload dibatalkan';
      case 'object-not-found':
        return 'File tidak ditemukan';
      case 'bucket-not-found':
        return 'Storage bucket tidak ditemukan';
      case 'project-not-found':
        return 'Project tidak ditemukan';
      case 'quota-exceeded':
        return 'Kuota penyimpanan habis';
      case 'unauthenticated':
        return 'Silakan login terlebih dahulu';
      case 'retry-limit-exceeded':
        return 'Gagal upload. Coba lagi.';
      default:
        return 'Terjadi kesalahan storage: $code';
    }
  }
}
