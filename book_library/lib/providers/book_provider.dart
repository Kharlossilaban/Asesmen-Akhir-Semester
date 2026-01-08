import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/storage_service.dart';

/// Book Provider - manages books data with Firestore and Storage
class BookProvider extends ChangeNotifier {
  final BookService _bookService = BookService();
  final StorageService _storageService = StorageService();

  // State variables
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _booksSubscription;

  // Getters
  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error state
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Fetch all books for a user (one-time fetch)
  Future<void> fetchBooks(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      _books = await _bookService.fetchBooks(userId);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Subscribe to real-time book updates
  void subscribeToBooksStream(String userId) {
    _booksSubscription?.cancel();
    _setLoading(true);

    _booksSubscription = _bookService
        .getBooksStream(userId)
        .listen(
          (books) {
            _books = books;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            _setError(error.toString());
            _setLoading(false);
          },
        );
  }

  /// Unsubscribe from books stream
  void unsubscribeFromBooksStream() {
    _booksSubscription?.cancel();
    _booksSubscription = null;
  }

  /// Add a new book with optional image upload
  Future<bool> addBook(Book book, {File? imageFile}) async {
    _setLoading(true);
    _setError(null);

    try {
      String coverUrl = book.coverUrl;

      // Upload image if provided
      if (imageFile != null && book.userId.isNotEmpty) {
        coverUrl = await _storageService.uploadBookCover(
          imageFile: imageFile,
          userId: book.userId,
          bookId: book.id,
        );
      }

      // Create book with cover URL
      final bookWithCover = book.copyWith(coverUrl: coverUrl);

      // Add to Firestore
      final newId = await _bookService.addBook(bookWithCover);

      // Add to local list with new ID
      final newBook = bookWithCover.copyWith(id: newId);
      _books.insert(0, newBook);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Update an existing book with optional new image
  Future<bool> updateBook(Book book, {File? newImageFile}) async {
    _setLoading(true);
    _setError(null);

    try {
      String coverUrl = book.coverUrl;

      // Upload new image if provided
      if (newImageFile != null && book.userId.isNotEmpty) {
        // Delete old image if exists
        if (book.coverUrl.isNotEmpty) {
          await _storageService.deleteBookCoverByUrl(book.coverUrl);
        }

        // Upload new image
        coverUrl = await _storageService.uploadBookCover(
          imageFile: newImageFile,
          userId: book.userId,
          bookId: book.id,
        );
      }

      // Update book with new cover URL
      final updatedBook = book.copyWith(
        coverUrl: coverUrl,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _bookService.updateBook(updatedBook);

      // Update local list
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = updatedBook;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Delete a book and its cover image
  Future<bool> deleteBook(String bookId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Find the book to get cover URL
      final book = _books.firstWhere(
        (b) => b.id == bookId,
        orElse: () => throw 'Buku tidak ditemukan',
      );

      // Delete cover image if exists
      if (book.coverUrl.isNotEmpty) {
        await _storageService.deleteBookCoverByUrl(book.coverUrl);
      }

      // Delete from Firestore
      await _bookService.deleteBook(bookId);

      // Remove from local list
      _books.removeWhere((b) => b.id == bookId);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Get a book by ID from local cache
  Book? getBookById(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh books from server
  Future<void> refreshBooks(String userId) async {
    await fetchBooks(userId);
  }

  /// Clear all books (for logout)
  void clearBooks() {
    _books = [];
    unsubscribeFromBooksStream();
    notifyListeners();
  }

  @override
  void dispose() {
    unsubscribeFromBooksStream();
    super.dispose();
  }
}
