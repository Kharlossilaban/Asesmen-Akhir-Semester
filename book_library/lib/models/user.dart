import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model - represents a user in the app
class AppUser {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create User from Firestore document
  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert User to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy of User with updated fields
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
