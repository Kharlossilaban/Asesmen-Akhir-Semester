import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/book.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../utils/error_handler.dart';
import '../utils/theme.dart';

/// Book Form Screen - for adding or editing a book
class BookFormScreen extends StatefulWidget {
  final Book? book; // null for add, book for edit

  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  final _reviewController = TextEditingController();

  String? _selectedGenre;
  String _selectedStatus = 'unread';
  double _rating = 0.0;
  File? _selectedImage;
  String _existingCoverUrl = '';
  bool _isLoading = false;

  bool get isEditMode => widget.book != null;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _yearController.text = widget.book!.year.toString();
      _reviewController.text = widget.book!.review;
      _selectedGenre = widget.book!.genre;
      _selectedStatus = widget.book!.status;
      _rating = widget.book!.rating;
      _existingCoverUrl = widget.book!.coverUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 1200,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGenre == null) {
      ErrorHandler.showErrorSnackBar(context, 'Pilih genre buku');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final bookProvider = context.read<BookProvider>();

      final book = Book(
        id: widget.book?.id ?? const Uuid().v4(),
        userId: authProvider.userId ?? '',
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        genre: _selectedGenre!,
        status: _selectedStatus,
        rating: _rating,
        review: _reviewController.text.trim(),
        coverUrl: _existingCoverUrl,
        createdAt: widget.book?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (isEditMode) {
        // Update with optional new image
        success = await bookProvider.updateBook(
          book,
          newImageFile: _selectedImage,
        );
      } else {
        // Add with optional image
        success = await bookProvider.addBook(book, imageFile: _selectedImage);
      }

      if (!mounted) return;

      if (success) {
        ErrorHandler.showSuccessSnackBar(
          context,
          isEditMode ? 'Buku berhasil diperbarui' : 'Buku berhasil ditambahkan',
        );
        Navigator.pop(context, true);
      } else {
        ErrorHandler.showErrorSnackBar(
          context,
          bookProvider.error ?? 'Gagal menyimpan buku',
        );
      }
    } catch (e) {
      ErrorHandler.showErrorSnackBar(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Buku' : 'Tambah Buku')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : _existingCoverUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _existingCoverUrl,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap untuk pilih gambar cover',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Buku *',
                      hintText: 'Masukkan judul buku',
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: Validators.validateBookTitle,
                  ),
                  const SizedBox(height: 16),

                  // Author
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Penulis *',
                      hintText: 'Masukkan nama penulis',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: Validators.validateAuthor,
                  ),
                  const SizedBox(height: 16),

                  // Year
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Tahun Terbit *',
                      hintText: 'contoh: 2023',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validateYear,
                  ),
                  const SizedBox(height: 16),

                  // Genre dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGenre,
                    decoration: const InputDecoration(
                      labelText: 'Genre *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: AppConstants.genres.map((genre) {
                      return DropdownMenuItem(value: genre, child: Text(genre));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedGenre = value);
                    },
                    validator: Validators.validateGenre,
                  ),
                  const SizedBox(height: 16),

                  // Status dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status Bacaan *',
                      prefixIcon: Icon(Icons.bookmark),
                    ),
                    items: AppConstants.statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          AppConstants.statusLabels[status] ?? status,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedStatus = value ?? 'unread');
                    },
                  ),
                  const SizedBox(height: 24),

                  // Rating slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          ...List.generate(5, (index) {
                            return Icon(
                              index < _rating.floor()
                                  ? Icons.star
                                  : (index < _rating
                                        ? Icons.star_half
                                        : Icons.star_border),
                              color: Colors.amber.shade600,
                              size: 20,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            _rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Slider(
                        value: _rating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          setState(() => _rating = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Review
                  TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Review (opsional)',
                      hintText: 'Tulis review atau catatan tentang buku ini',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEditMode ? 'Simpan Perubahan' : 'Tambah Buku',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Menyimpan buku...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
