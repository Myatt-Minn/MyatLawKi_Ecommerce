class Product {
  final int id;
  final String name;
  final String description;
  final String brand;
  final String category;
  final double price;
  final List<VolumePrice> volumePrices;
  final String status;
  final List<String> images;
  final int stock;
  final List<Variation> variations;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.category,
    required this.price,
    required this.volumePrices,
    required this.status,
    required this.images,
    required this.stock,
    required this.variations,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      brand: json['brand'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      volumePrices: (json['volume_prices'] as List)
          .map((vp) => VolumePrice.fromJson(vp))
          .toList(),
      status: json['status'],
      images: List<String>.from(json['images']),
      stock: json['stock'],
      variations: (json['variations'] as List)
          .map((v) => Variation.fromJson(v))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'brand': brand,
      'category': category,
      'price': price,
      'volume_prices': volumePrices.map((vp) => vp.toJson()).toList(),
      'status': status,
      'images': images,
      'stock': stock,
      'variations': variations.map((v) => v.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class VolumePrice {
  final int id;
  final int productId;
  final int quantity;
  final String discountPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int productVariationId;

  VolumePrice({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.discountPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.productVariationId,
  });

  factory VolumePrice.fromJson(Map<String, dynamic> json) {
    return VolumePrice(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      discountPrice: json['discount_price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productVariationId: json['product_variation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'discount_price': discountPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'product_variation_id': productVariationId,
    };
  }
}

class Variation {
  final int id;
  final String name;
  final String type;
  final List<VariationOption> options;

  Variation({
    required this.id,
    required this.name,
    required this.type,
    required this.options,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      options: (json['options'] as List)
          .map((option) => VariationOption.fromJson(option))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

class VariationOption {
  final String name;
  final int quantity;
  final double price;

  VariationOption({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory VariationOption.fromJson(Map<String, dynamic> json) {
    return VariationOption(
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
