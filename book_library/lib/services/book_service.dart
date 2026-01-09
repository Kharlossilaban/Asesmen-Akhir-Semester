import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

/// Book Service - handles Firestore CRUD operations for books
class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get reference to books collection
  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _firestore.collection('books');

  /// Fetch all books for a specific user
  Future<List<Book>> fetchBooks(String userId) async {
    try {
      final snapshot = await _booksCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Book.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal mengambil data buku: $e';
    }
  }

  /// Get real-time stream of books for a user
  Stream<List<Book>> getBooksStream(String userId) {
    return _booksCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Book.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Add a new book
  Future<String> addBook(Book book) async {
    try {
      final docRef = await _booksCollection.add(book.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal menambahkan buku: $e';
    }
  }

  /// Update an existing book
  Future<void> updateBook(Book book) async {
    try {
      await _booksCollection.doc(book.id).update(book.toJson());
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal memperbarui buku: $e';
    }
  }

  /// Delete a book
  Future<void> deleteBook(String bookId) async {
    try {
      await _booksCollection.doc(bookId).delete();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal menghapus buku: $e';
    }
  }

  /// Get a single book by ID
  Future<Book?> getBook(String bookId) async {
    try {
      final doc = await _booksCollection.doc(bookId).get();
      if (doc.exists && doc.data() != null) {
        return Book.fromJson(doc.data()!, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal mengambil buku: $e';
    }
  }

  /// Search books by title or author
  Future<List<Book>> searchBooks(String userId, String query) async {
    try {
      // Firestore doesn't support full-text search, so we fetch all and filter
      final books = await fetchBooks(userId);
      final lowerQuery = query.toLowerCase();

      return books.where((book) {
        return book.title.toLowerCase().contains(lowerQuery) ||
            book.author.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw 'Gagal mencari buku: $e';
    }
  }

  /// Get books by status
  Future<List<Book>> getBooksByStatus(String userId, String status) async {
    try {
      final snapshot = await _booksCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Book.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirestoreError(e.code);
    } catch (e) {
      throw 'Gagal mengambil buku: $e';
    }
  }

  /// Handle Firestore errors
  String _handleFirestoreError(String code) {
    switch (code) {
      case 'failed-precondition':
        return 'Database belum siap. Pastikan Firestore Database sudah dibuat di Firebase Console (Cloud Firestore → Create Database → Test Mode).';
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
}
