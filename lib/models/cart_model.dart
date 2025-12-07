class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String userId;
  final List<CartItem> items;
  final double totalAmount;

  CartModel({
    required this.userId,
    required this.items,
  }) : totalAmount = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      userId: map['userId'] ?? '',
      items: List<CartItem>.from(
        (map['items'] as List<dynamic>? ?? []).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }
}
