import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;
  final List<String> wishlist;
  final Map<String, dynamic>? address;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.role = 'user',
    required this.createdAt,
    this.wishlist = const [],
    this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? 'User',
      profileImage: data['profileImage'],
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      wishlist: List<String>.from(data['wishlist'] ?? []),
      address: data['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'wishlist': wishlist,
      'address': address,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    String? role,
    DateTime? createdAt,
    List<String>? wishlist,
    Map<String, dynamic>? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      wishlist: wishlist ?? this.wishlist,
      address: address ?? this.address,
    );
  }
}
