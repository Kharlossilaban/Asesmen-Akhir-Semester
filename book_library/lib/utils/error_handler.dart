import 'package:flutter/material.dart';

/// Error handling utilities for displaying errors to users

class ErrorHandler {
  /// Show error message in SnackBar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success message in SnackBar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info message in SnackBar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Handle Firebase Auth errors
  static String handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'invalid-credential':
        return 'Email atau password salah';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }

  /// Handle Firebase Firestore errors
  static String handleFirestoreError(String code) {
    switch (code) {
      case 'permission-denied':
        return 'Tidak memiliki izin untuk mengakses data';
      case 'unavailable':
        return 'Layanan tidak tersedia. Periksa koneksi internet.';
      case 'not-found':
        return 'Data tidak ditemukan';
      case 'already-exists':
        return 'Data sudah ada';
      case 'resource-exhausted':
        return 'Kuota habis. Coba lagi nanti.';
      case 'cancelled':
        return 'Operasi dibatalkan';
      case 'deadline-exceeded':
        return 'Waktu operasi habis. Coba lagi.';
      default:
        return 'Terjadi kesalahan database: $code';
    }
  }

  /// Handle Firebase Storage errors
  static String handleStorageError(String code) {
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
        return 'Terjadi kesalahan upload: $code';
    }
  }
}
