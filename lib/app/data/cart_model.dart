class CartItem {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  final String color;
  final int quantity;
  final int stock; // Add this property to track available stock

  CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.color,
    required this.quantity,
    required this.stock,
  });

  CartItem copyWith({
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    String? size,
    String? color,
    int? quantity,
    int? stock,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'color': color,
      'quantity': quantity,
      'stock': stock,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'],
      stock: json['stock'], // Ensure this is included in your JSON
    );
  }
}
