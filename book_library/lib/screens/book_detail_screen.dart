import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/book.dart';
import '../providers/book_provider.dart';
import '../utils/constants.dart';
import '../utils/error_handler.dart';
import '../utils/theme.dart';
import 'book_form_screen.dart';

/// Book Detail Screen - displays complete book information
class BookDetailScreen extends StatelessWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await ErrorHandler.showConfirmDialog(
      context,
      title: 'Hapus Buku',
      message: 'Apakah Anda yakin ingin menghapus buku ini?',
      confirmText: 'Hapus',
      confirmColor: Colors.red,
    );

    if (confirmed && context.mounted) {
      final bookProvider = context.read<BookProvider>();
      final success = await bookProvider.deleteBook(bookId);

      if (context.mounted) {
        if (success) {
          ErrorHandler.showSuccessSnackBar(context, 'Buku berhasil dihapus');
          Navigator.pop(context, true);
        } else {
          ErrorHandler.showErrorSnackBar(
            context,
            bookProvider.error ?? 'Gagal menghapus buku',
          );
        }
      }
    }
  }

  void _handleEdit(BuildContext context, Book book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookFormScreen(book: book)),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        final book = bookProvider.getBookById(bookId);

        if (book == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Buku')),
            body: const Center(child: Text('Buku tidak ditemukan')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Buku'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _handleEdit(context, book),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _handleDelete(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover image
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey.shade100,
                  child: book.coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Author
                      Text(
                        'oleh ${book.author}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Genre, Year, Status
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildInfoChip(Icons.category, book.genre),
                          _buildInfoChip(
                            Icons.calendar_today,
                            book.year.toString(),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppConstants.statusColors[book.status]
                                      ?.withValues(alpha: 0.2) ??
                                  Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppConstants.statusLabels[book.status] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    AppConstants.statusColors[book.status] ??
                                    Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Rating
                      Row(
                        children: [
                          const Text(
                            'Rating: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ...List.generate(5, (index) {
                            return Icon(
                              index < book.rating.floor()
                                  ? Icons.star
                                  : (index < book.rating
                                        ? Icons.star_half
                                        : Icons.star_border),
                              color: Colors.amber.shade600,
                              size: 24,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            book.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Review
                      if (book.review.isNotEmpty) ...[
                        const Text(
                          'Review',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            book.review,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.book,
        size: 80,
        color: AppTheme.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
