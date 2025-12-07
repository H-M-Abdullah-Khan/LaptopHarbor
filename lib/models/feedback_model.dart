import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String status; // 'open', 'closed'

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
    this.status = 'open',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FeedbackModel(
      id: documentId,
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'open',
    );
  }
}
