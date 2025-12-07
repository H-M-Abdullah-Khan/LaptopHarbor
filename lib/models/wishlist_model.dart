import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime addedAt;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map, String documentId) {
    return WishlistModel(
      id: documentId,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      addedAt: (map['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
