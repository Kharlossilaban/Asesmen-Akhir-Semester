import 'package:flutter/material.dart';

/// Application Constants
class AppConstants {
  // App Info
  static const String appName = 'Book Library';
  static const String appVersion = '1.0.0';

  // Genre Options
  static const List<String> genres = [
    'Fiksi',
    'Non-Fiksi',
    'Novel',
    'Komik',
    'Biografi',
    'Sejarah',
    'Sains',
    'Teknologi',
    'Bisnis',
    'Self-Help',
    'Agama',
    'Lainnya',
  ];

  // Reading Status Options
  static const List<String> statusOptions = ['unread', 'reading', 'finished'];

  // Status Labels (untuk display)
  static const Map<String, String> statusLabels = {
    'all': 'Semua',
    'unread': 'Belum Dibaca',
    'reading': 'Sedang Dibaca',
    'finished': 'Selesai',
  };

  // Status Colors
  static const Map<String, Color> statusColors = {
    'unread': Color(0xFF9E9E9E),
    'reading': Color(0xFF2196F3),
    'finished': Color(0xFF4CAF50),
  };

  // Error Messages
  static const String networkError =
      'Tidak ada koneksi internet. Periksa koneksi Anda.';
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui.';
  static const String authError = 'Gagal melakukan autentikasi.';
  static const String permissionError =
      'Anda tidak memiliki izin untuk mengakses data ini.';
}
