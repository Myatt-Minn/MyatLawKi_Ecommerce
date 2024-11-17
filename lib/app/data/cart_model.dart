class CartItem {
  final int productId;
  final int productVariationId;
  final int optionId;
  int? quantity;
  final double price;
  final String name;
  final String size;
  final String color;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.productVariationId,
    required this.optionId,
    required this.quantity,
    required this.price,
    required this.name,
    required this.color,
    required this.size,
    required this.imageUrl,
  });

  // Convert CartItem to a map (for storing in Firestore or local storage)
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_variation_id': productVariationId,
      'option_id': optionId,
      'quantity': quantity,
      'price': price,
      'name': name,
      'size': size,
      'color': color,
      'imageUrl': imageUrl
    };
  }

  // Convert map to CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['product_id'],
      productVariationId: map['product_variation_id'],
      optionId: map['option_id'],
      quantity: map['quantity'],
      price: map['price'],
      name: map['name'],
      size: map['size'],
      color: map['color'],
      imageUrl: map['imageUrl'],
    );
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
        productId: productId,
        productVariationId: productVariationId,
        optionId: optionId,
        quantity: quantity ?? this.quantity,
        price: price,
        name: name,
        size: size,
        color: color,
        imageUrl: imageUrl);
  }
}
