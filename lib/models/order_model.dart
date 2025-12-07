import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptopharbor/models/cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final Map<String, dynamic> shippingAddress;
  final String status; // 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  final DateTime orderDate;
  final String paymentMethod;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    this.trackingNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentMethod': paymentMethod,
      'trackingNumber': trackingNumber,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      items: List<CartItem>.from(
        (map['items'] as List<dynamic>? ?? []).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
      status: map['status'] ?? 'pending',
      orderDate: (map['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? 'COD',
      trackingNumber: map['trackingNumber'],
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? totalAmount,
    Map<String, dynamic>? shippingAddress,
    String? status,
    DateTime? orderDate,
    String? paymentMethod,
    String? trackingNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }
}
