import 'package:cloud_firestore/cloud_firestore.dart';

/// Book Model - represents a book in the library
class Book {
  final String id;
  final String userId;
  final String title;
  final String author;
  final int year;
  final String genre;
  final String status; // unread, reading, finished
  final double rating;
  final String review;
  final String coverUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required this.status,
    this.rating = 0.0,
    this.review = '',
    this.coverUrl = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create Book from Firestore document
  factory Book.fromJson(Map<String, dynamic> json, String id) {
    return Book(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      year: json['year'] ?? 0,
      genre: json['genre'] ?? '',
      status: json['status'] ?? 'unread',
      rating: (json['rating'] ?? 0.0).toDouble(),
      review: json['review'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert Book to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'status': status,
      'rating': rating,
      'review': review,
      'coverUrl': coverUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy of Book with updated fields
  Book copyWith({
    String? id,
    String? userId,
    String? title,
    String? author,
    int? year,
    String? genre,
    String? status,
    double? rating,
    String? review,
    String? coverUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      coverUrl: coverUrl ?? this.coverUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
