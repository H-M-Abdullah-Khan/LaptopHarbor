import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String brandId;
  final String categoryId;
  final Map<String, dynamic> specs; // e.g., {'ram': '16GB', 'processor': 'M1'}
  final int stock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.brandId,
    required this.categoryId,
    required this.specs,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    this.isFeatured = false,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: data['discountPrice']?.toDouble(),
      images: List<String>.from(data['images'] ?? []),
      brandId: data['brandId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      specs: Map<String, dynamic>.from(data['specs'] ?? {}),
      stock: data['stock'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'images': images,
      'brandId': brandId,
      'categoryId': categoryId,
      'specs': specs,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'isFeatured': isFeatured,
    };
  }
}
