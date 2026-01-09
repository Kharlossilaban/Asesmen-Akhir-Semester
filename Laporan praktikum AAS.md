# LAPORAN PRAKTIKUM ASESMEN AKHIR SEMESTER
## Pemrograman Mobile - Personal Book Library

---

## 1. IDENTITAS MAHASISWA

| Data | Keterangan |
|------|------------|
| **Nama** | Kharlos Silaban |
| **NIM** | [ISI NIM ANDA] |
| **Kelas** | [ISI KELAS ANDA] |
| **Mata Kuliah** | Pemrograman Mobile |
| **Dosen Pengampu** | [ISI NAMA DOSEN] |

---

## 2. TEMA APLIKASI

### Personal Book Library

Aplikasi **Personal Book Library** adalah aplikasi mobile berbasis Flutter untuk manajemen koleksi buku pribadi. Aplikasi ini memungkinkan pengguna untuk:

- **Mengelola Koleksi Buku** - Menyimpan informasi buku yang dimiliki secara digital
- **Tracking Status Bacaan** - Melacak buku yang sudah dibaca, sedang dibaca, atau belum dibaca
- **Rating & Review** - Memberikan penilaian dan catatan untuk setiap buku
- **Pencarian & Filter** - Mencari buku berdasarkan judul/penulis dan memfilter berdasarkan status

### Alasan Pemilihan Tema

Tema ini dipilih karena:
1. **Relevan** - Banyak orang yang membaca buku dan butuh sistem katalog pribadi
2. **Praktis** - Implementasi CRUD operations yang jelas dan terstruktur
3. **Komprehensif** - Mencakup semua aspek mobile development (UI/UX, State Management, Database, Authentication)
4. **Cloud-Based** - Menggunakan Firebase untuk demonstrasi integrasi dengan backend cloud

---

## 3. TAMPILAN ANTARMUKA (UI) DAN FUNGSIONALITAS

### 3.1 Splash Screen

![Splash Screen](../uploaded_image_1767866561297.png)

**Fungsi Screen:**
- Menampilkan branding aplikasi saat pertama kali dibuka
- Melakukan pengecekan status autentikasi pengguna
- Redirect otomatis ke Login Screen atau Home Screen berdasarkan status login

**Detail Implementasi:**
- Animasi fade-in dan scale untuk logo aplikasi
- Gradient background dengan warna ungu primer
- Auto-navigation setelah 2 detik

---

### 3.2 Login & Register Screen

![Login Screen](../uploaded_image_1767868200463.png)

**Fungsi Screen:**
- **Login** - Autentikasi pengguna dengan email dan password
- **Register** - Pendaftaran pengguna baru dengan nama, email, dan password
- **Toggle Mode** - Beralih antara mode login dan register
- **Validasi Input** - Real-time validation untuk semua field

**Detail Implementasi:**
- Form dengan validasi email format, password minimal 6 karakter
- Toggle show/hide password
- Error handling dengan pesan yang jelas
- Integrasi dengan Firebase Authentication

**Fungsionalitas Utama:**
1. **Autentikasi Aman** - Password disimpan dengan enkripsi di Firebase
2. **Session Persistence** - User tetap login meskipun aplikasi ditutup
3. **Error Handling** - Menampilkan pesan error yang user-friendly

---

### 3.3 Home Screen (Dashboard)

![Home Screen](../uploaded_image_1767935398517.png)

**Fungsi Screen:**
- Menampilkan daftar koleksi buku pengguna dalam bentuk card
- Filter buku berdasarkan status (Semua, Belum Dibaca, Sedang Dibaca, Selesai)
- Pencarian buku by judul atau nama penulis
- Navigasi ke detail buku atau form tambah buku

**Detail Implementasi:**
- **Greeting** - Menampilkan nama pengguna di AppBar
- **Filter Chips** - 3 chip untuk filter status dengan counter
- **Book Cards** - Card dengan informasi ringkas (cover, judul, penulis, genre, tahun, status, rating)
- **Floating Action Button** - Tombol tambah buku di kanan bawah
- **Pull-to-Refresh** - Refresh data dengan gesture swipe down
- **Search Icon** - Membuka search bar untuk pencarian

**Fungsionalitas Utama:**
1. **CRUD - Read** - Fetch dan display semua buku dari Firestore
2. **Filter Real-time** - Filter buku tanpa reload dari server
3. **Search** - Pencarian real-time by title/author
4. **State Management** - Menggunakan Provider untuk state buku

---

### 3.4 Book Detail Screen

**Fungsi Screen:**
- Menampilkan informasi lengkap buku yang dipilih
- Edit informasi buku
- Hapus buku dari koleksi
- Navigasi kembali ke home

**Detail Implementasi:**
- Cover buku (dari URL) dengan error handling
- Informasi lengkap: judul, penulis, tahun, genre, status, rating, review
- Action buttons: Edit dan Delete dengan konfirmasi
- Status badge dengan warna sesuai status buku

**Fungsionalitas Utama:**
1. **CRUD - Read Detail** - Menampilkan detail spesifik buku
2. **Navigation** - Route dengan parameter bookId
3. **Confirmation Dialog** - Konfirmasi sebelum delete

---

### 3.5 Add/Edit Book Screen

**Fungsi Screen:**
- Form untuk menambah buku baru
- Edit buku yang sudah ada
- Input semua informasi buku (judul, penulis, tahun, genre, status, rating, review, cover URL)
- Validasi input sebelum menyimpan

**Detail Implementasi:**
- **Form Fields:**
  - Text input: Judul, Penulis, Tahun
  - Dropdown: Genre (12 pilihan), Status (3 pilihan)
  - Slider: Rating (0-5 bintang dengan step 0.5)
  - Text area: Review/catatan
  - URL input: Link gambar cover
- **Image Preview** - Tampil preview gambar dari URL
- **Validation** - Required field validation dengan error message
- **Save/Cancel** - Tombol aksi dengan loading state

**Fungsionalitas Utama:**
1. **CRUD - Create** - Tambah buku baru ke Firestore
2. **CRUD - Update** - Edit buku existing
3. **Input Validation** - Validators untuk setiap field
4. **Error Handling** - Tampilkan error jika save gagal

---

## 4. DATABASE

### 4.1 Arsitektur Database

Aplikasi menggunakan **Firebase Cloud Firestore** sebagai database cloud NoSQL dengan struktur sebagai berikut:

#### Collection: `users`
```json
{
  "userId": {
    "email": "user@email.com",
    "name": "Nama User",
    "createdAt": "Timestamp"
  }
}
```

#### Collection: `books`
```json
{
  "bookId": {
    "userId": "user123",
    "title": "Judul Buku",
    "author": "Nama Penulis",
    "year": 2024,
    "genre": "Fiction",
    "status": "reading",
    "rating": 4.5,
    "review": "Review text",
    "coverUrl": "https://...",
    "createdAt": "Timestamp",
    "updatedAt": "Timestamp"
  }
}
```

### 4.2 Fitur Database

| Fitur | Implementasi |
|-------|-------------|
| **Real-time Sync** | ✅ Data sync otomatis antar devices |
| **Offline Mode** | ✅ Cache lokal untuk akses offline |
| **Security** | ✅ Firestore Rules untuk access control |
| **Scalability** | ✅ Auto-scaling dari Firebase |
| **Query** | ✅ Where, OrderBy, Filter |

### 4.3 Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
    match /books/{bookId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Penjelasan:**
- User hanya bisa akses data user mereka sendiri
- Semua user yang login bisa CRUD buku (dengan filter userId di app)
- User yang belum login tidak bisa akses data apapun

### 4.4 Indexes

Composite index untuk query optimization:

```json
{
  "collectionGroup": "books",
  "fields": [
    {"fieldPath": "userId", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}
```

---

## 5. STATE MANAGEMENT & DATA PERSISTENCE

### 5.1 Provider State Management

Aplikasi menggunakan **Provider Pattern** untuk state management dengan 3 provider utama:

#### AuthProvider
```dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  bool get isAuthenticated => _currentUser != null;
  String? get userId => _currentUser?.uid;
  
  // Methods
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String name);
  Future<void> logout();
}
```

**Penanganan State:**
- ✅ Auth state persisted di Firebase Auth
- ✅ Auto-login saat app restart (session tetap aktif)
- ✅ Logout clear semua state

#### BookProvider
```dart
class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;
  
  // Methods
  Future<void> fetchBooks(String userId);
  Future<bool> addBook(Book book);
  Future<bool> updateBook(Book book);
  Future<bool> deleteBook(String bookId);
}
```

**Penanganan State:**
- ✅ Data persisted di Firestore (cloud)
- ✅ Local cache untuk offline access
- ✅ Real-time sync dengan Firestore streams

#### FilterProvider
```dart
class FilterProvider extends ChangeNotifier {
  String _selectedStatus = 'all';
  String _searchQuery = '';
  
  List<Book> getFilteredBooks(List<Book> books);
}
```

**Penanganan State:**
- ✅ Filter state lokal (tidak perlu persist)
- ✅ Query real-time tanpa fetch ulang

### 5.2 Penanganan Rotasi Layar

**Implementasi:**

1. **Provider Pattern** - State disimpan di Provider, tidak di widget state
   ```dart
   // Widget rebuild saat rotasi, tapi data tetap ada di Provider
   Consumer<BookProvider>(
     builder: (context, bookProvider, child) {
       return ListView(children: bookProvider.books);
     }
   )
   ```

2. **Firestore Persistence** 
   - Data utama di cloud, bukan di memori lokal
   - Rotasi layar → Widget rebuild → Provider fetch dari cache/cloud
   - Data tidak hilang karena source of truth ada di Firestore

3. **TextEditingController** - Input field data preserved
   ```dart
   final _titleController = TextEditingController();
   
   @override
   void dispose() {
     _titleController.dispose(); // Proper cleanup
     super.dispose();
   }
   ```

### 5.3 Perpindahan Antar Halaman

**Navigation dengan Data Passing:**

```dart
// Passing book ID ke detail screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BookDetailScreen(bookId: book.id)
  )
);

// Di BookDetailScreen, fetch data dari Provider
final book = Provider.of<BookProvider>(context).getBookById(bookId);
```

**Penanganan State:**
- ✅ Data tidak hilang saat back navigation (data di Provider)
- ✅ Refresh data saat kembali dari form edit (result callback)
- ✅ Deep linking support dengan bookId parameter

### 5.4 Lifecycle Management

**Proper Disposal:**
```dart
@override
void dispose() {
  _bookProvider.unsubscribeFromBooksStream(); // Stop listening
  _titleController.dispose(); // Release resources
  super.dispose();
}
```

**Init State:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadBooks(); // Load data after widget build
  });
}
```

---

## 6. LINK REPOSITORY

### GitHub Repository
**URL:** [https://github.com/Kharlossilaban/Asesmen-Akhir-Semester](https://github.com/Kharlossilaban/Asesmen-Akhir-Semester)

**Isi Repository:**
- ✅ Source code lengkap Flutter project
- ✅ File konfigurasi Firebase (`google-services.json`)
- ✅ APK release (49.4 MB)
- ✅ Dokumentasi (`FIREBASE_SETUP.md`, `hasil_implementasi.md`)
- ✅ Firestore indexes configuration

**Branch:** `main`

**Cara Clone:**
```bash
git clone https://github.com/Kharlossilaban/Asesmen-Akhir-Semester.git
cd Asesmen-Akhir-Semester/book_library
flutter pub get
flutter run
```

---

## 7. FITUR-FITUR UNGGULAN

### 7.1 Fitur Utama (4 Dynamic Features)

| No | Fitur | Status | Keterangan |
|----|-------|--------|------------|
| 1 | **CRUD Operations** | ✅ | Create, Read, Update, Delete buku dengan Firestore |
| 2 | **Filter & Search** | ✅ | Filter by status, search by title/author |
| 3 | **Rating & Review** | ✅ | Rating 0-5 bintang, catatan text panjang |
| 4 | **Image Display** | ✅ | Cover buku dari URL dengan preview |

### 7.2 Teknologi yang Digunakan

| Teknologi | Versi | Penggunaan |
|-----------|-------|------------|
| **Flutter** | 3.x | Framework mobile |
| **Dart** | 3.x | Programming language |
| **Firebase Auth** | Latest | Autentikasi user |
| **Cloud Firestore** | Latest | NoSQL database |
| **Provider** | ^6.0.0 | State management |
| **Google Fonts** | ^6.3.3 | Typography (Poppins) |
| **Image Picker** | ^1.0.4 | Pick images |
| **UUID** | ^4.2.1 | Generate unique IDs |

### 7.3 Arsitektur Aplikasi

```
lib/
├── main.dart              # Entry point + Firebase init
├── models/                # Data models
│   ├── book.dart
│   └── user.dart
├── services/              # Firebase services
│   ├── auth_service.dart
│   └── book_service.dart
├── providers/             # State management
│   ├── auth_provider.dart
│   ├── book_provider.dart
│   └── filter_provider.dart
├── screens/               # UI screens (5 screens)
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── book_detail_screen.dart
│   └── book_form_screen.dart
├── widgets/               # Reusable widgets
│   ├── book_card.dart
│   ├── filter_chips.dart
│   ├── custom_text_field.dart
│   ├── loading_overlay.dart
│   └── rating_display.dart
└── utils/                 # Utilities
    ├── constants.dart
    ├── theme.dart
    ├── validators.dart
    └── error_handler.dart
```

---

## 8. KESIMPULAN

Aplikasi **Personal Book Library** berhasil diimplementasikan dengan semua fitur yang direncanakan. Aplikasi ini mendemonstrasikan:

1. ✅ **Mobile Development Best Practices**
   - Clean architecture dengan separation of concerns
   - Proper state management menggunakan Provider
   - Error handling yang komprehensif

2. ✅ **Firebase Integration**
   - Authentication dengan email/password
   - Cloud Firestore untuk database real-time
   - Firestore rules untuk security

3. ✅ **UI/UX Excellence**
   - Material Design 3 implementation
   - Responsive layout
   - User-friendly interface

4. ✅ **Data Persistence**
   - State tetap ada saat rotasi layar
   - Data tidak hilang saat perpindahan halaman
   - Offline support dengan Firestore cache

Aplikasi ini siap untuk digunakan dan dapat dikembangkan lebih lanjut dengan fitur-fitur tambahan seperti:
- Export/import data
- Barcode scanner untuk input buku
- Social sharing untuk rekomendasi buku
- Dark mode toggle

---

**Tanggal Pengumpulan:** 9 Januari 2026
**Status:** ✅ SELESAI & TESTED

---

## LAMPIRAN

### A. Struktur Database Detail

![Database Structure](placeholder_database.png)

### B. Flowchart Aplikasi

![App Flowchart](placeholder_flowchart.png)

### C. Testing Screenshots

Semua fitur sudah ditest dan berfungsi dengan baik:
- ✅ Login/Register
- ✅ CRUD Buku
- ✅ Filter & Search
- ✅ Rating
- ✅ Rotasi layar
- ✅ Perpindahan halaman

---

**END OF REPORT**
