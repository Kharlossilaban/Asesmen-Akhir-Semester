/// Input Validators for Form Fields
library;

class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak sama';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }

    return null;
  }

  /// Validate book title
  static String? validateBookTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul buku tidak boleh kosong';
    }

    if (value.length < 2) {
      return 'Judul minimal 2 karakter';
    }

    return null;
  }

  /// Validate author name
  static String? validateAuthor(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama penulis tidak boleh kosong';
    }

    return null;
  }

  /// Validate year
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tahun tidak boleh kosong';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'Tahun harus berupa angka';
    }

    if (year < 1000 || year > DateTime.now().year) {
      return 'Tahun tidak valid';
    }

    return null;
  }

  /// Validate genre selection
  static String? validateGenre(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pilih genre buku';
    }

    return null;
  }

  /// Validate status selection
  static String? validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pilih status bacaan';
    }

    return null;
  }

  /// Validate required field (generic)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    return null;
  }
}
