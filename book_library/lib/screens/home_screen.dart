import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../providers/filter_provider.dart';
import '../utils/error_handler.dart';
import '../widgets/book_card.dart';
import '../widgets/filter_chips.dart';
import 'login_screen.dart';
import 'book_detail_screen.dart';
import 'book_form_screen.dart';

/// Home Screen - displays list of books with filter and search
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Load books when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBooks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    final authProvider = context.read<AuthProvider>();
    final bookProvider = context.read<BookProvider>();

    if (authProvider.userId != null) {
      await bookProvider.fetchBooks(authProvider.userId!);
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await ErrorHandler.showConfirmDialog(
      context,
      title: 'Logout',
      message: 'Apakah Anda yakin ingin keluar?',
      confirmText: 'Keluar',
      confirmColor: Colors.red,
    );

    if (confirmed && mounted) {
      final authProvider = context.read<AuthProvider>();
      final bookProvider = context.read<BookProvider>();

      // Clear books before logout
      bookProvider.clearBooks();
      await authProvider.logout();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  void _openSearch() {
    setState(() => _isSearching = true);
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      context.read<FilterProvider>().setSearchQuery('');
    });
  }

  void _onSearchChanged(String query) {
    context.read<FilterProvider>().setSearchQuery(query);
  }

  void _navigateToAddBook() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookFormScreen()),
    );

    if (result == true && mounted) {
      // Book was added, refresh if needed
      // The list should auto-update if using stream, otherwise:
      _loadBooks();
    }
  }

  void _navigateToBookDetail(String bookId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: bookId)),
    );

    if (result == true && mounted) {
      // Book was modified/deleted, refresh if needed
      _loadBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari buku...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _onSearchChanged,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Koleksi Buku'),
                  if (authProvider.userName != null)
                    Text(
                      'Halo, ${authProvider.userName}!',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
        actions: [
          if (_isSearching)
            IconButton(icon: const Icon(Icons.close), onPressed: _closeSearch)
          else
            IconButton(icon: const Icon(Icons.search), onPressed: _openSearch),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          const FilterChipsWidget(),

          // Books list
          Expanded(
            child: Consumer2<BookProvider, FilterProvider>(
              builder: (context, bookProvider, filterProvider, _) {
                if (bookProvider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat buku...'),
                      ],
                    ),
                  );
                }

                if (bookProvider.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            bookProvider.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadBooks,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredBooks = filterProvider.getFilteredBooks(
                  bookProvider.books,
                );

                if (filteredBooks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            filterProvider.hasActiveFilters
                                ? 'Tidak ada buku yang sesuai filter'
                                : 'Belum ada buku',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filterProvider.hasActiveFilters
                                ? 'Coba ubah filter pencarian'
                                : 'Tap tombol + untuk menambah buku baru',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!filterProvider.hasActiveFilters) ...[
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _navigateToAddBook,
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Buku'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadBooks,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return BookCard(
                        book: book,
                        onTap: () => _navigateToBookDetail(book.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddBook,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
