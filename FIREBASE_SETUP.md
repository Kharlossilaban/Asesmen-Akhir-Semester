# Setup Firebase untuk Personal Book Library

## ⚠️ Error "failed-precondition" - SOLUSI

Error ini terjadi karena **Firestore Database belum dibuat**. Ikuti langkah berikut:

---

## 🔥 Langkah-Langkah Setup Firebase

### 1. Firestore Database (WAJIB)

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **book-library-69ed3**
3. Klik menu **"Firestore Database"** di sidebar kiri
4. Klik tombol **"Create database"**
5. Pilih **"Start in test mode"** (untuk development)
   ```
   ⚠️ PENTING: Pilih "test mode" agar tidak perlu setup rules dulu
   ```
6. Pilih **location**: **asia-southeast1** (Jakarta) atau **asia-southeast2** (Singapore)
7. Klik **"Enable"**
8. Tunggu sampai database selesai dibuat (±1-2 menit)

---

### 2. Authentication (Email/Password)

1. Di Firebase Console, klik menu **"Authentication"**
2. Klik tab **"Sign-in method"**
3. Klik **"Email/Password"**
4. **Enable** toggle pertama (Email/Password)
5. Klik **"Save"**

---

### 3. Firestore Rules (Test Mode - Otomatis)

Jika Anda pilih "test mode", rules sudah otomatis:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2026, 3, 10);
    }
  }
}
```

⚠️ **Rules ini expired dalam 30 hari!** Untuk production, ubah ke:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Books collection
    match /books/{bookId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

### 4. Firestore Indexes (OPSIONAL - Untuk Performa)

Jika masih ada error setelah create database, buat index manual:

1. Di Firebase Console → **Firestore Database** → Tab **"Indexes"**
2. Klik **"Add Index"**
3. **Collection ID**: `books`
4. **Fields**:
   - Field: `userId`, Order: **Ascending**
   - Field: `createdAt`, Order: **Descending**
5. Klik **"Create"**

Atau gunakan file `firestore.indexes.json` yang sudah disediakan.

---

## ✅ Checklist Setup

- [ ] Firestore Database created (test mode)
- [ ] Authentication Email/Password enabled
- [ ] Firestore Rules (test mode sudah otomatis)
- [ ] Indexes (opsional, bisa dibuat nanti)

---

## 🧪 Test Aplikasi

Setelah setup:
1. **Uninstall** aplikasi dari HP
2. **Install ulang** APK
3. **Register** akun baru
4. **Login** dan test tambah buku
5. Jika masih error, cek Firebase Console → Firestore Database apakah collection "books" sudah ada

---

## 🆘 Troubleshooting

**Error "failed-precondition"** → Database belum dibuat (ikuti Step 1)
**Error "permission-denied"** → Rules belum benar (ikuti Step 3)
**Error "unavailable"** → Koneksi internet bermasalah

---

**Lokasi Project**: `d:\Ujian\book_library`
**Firebase Project**: book-library-69ed3
