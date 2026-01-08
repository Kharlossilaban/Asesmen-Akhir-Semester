import 'package:flutter/material.dart';
import '../models/book.dart';

/// Filter Provider - manages filter and search state
class FilterProvider extends ChangeNotifier {
  // State variables
  String _selectedStatus = 'all';
  String _searchQuery = '';

  // Getters
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  /// Set selected status filter
  void setStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedStatus = 'all';
    _searchQuery = '';
    notifyListeners();
  }

  /// Get filtered books based on current filters
  List<Book> getFilteredBooks(List<Book> allBooks) {
    List<Book> filteredBooks = allBooks;

    // Filter by status
    if (_selectedStatus != 'all') {
      filteredBooks = filteredBooks
          .where((book) => book.status == _selectedStatus)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredBooks = filteredBooks.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList();
    }

    return filteredBooks;
  }

  /// Check if any filter is active
  bool get hasActiveFilters {
    return _selectedStatus != 'all' || _searchQuery.isNotEmpty;
  }
}
