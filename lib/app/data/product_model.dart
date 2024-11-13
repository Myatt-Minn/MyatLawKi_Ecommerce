class Product {
  final int id;
  final String name;
  final String description;
  final String brand;
  final String category;
  final double price;
  final List<dynamic> volumePrices; // Empty array, possibly used in future
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
      volumePrices: List<dynamic>.from(json['volume_prices']),
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
      'volume_prices': volumePrices,
      'status': status,
      'images': images,
      'stock': stock,
      'variations': variations.map((v) => v.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Variation {
  final int id;
  final String name;
  final String type;
  final List<List<VariationOption>> options;

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
          .map((optionList) => (optionList as List)
              .map((option) => VariationOption.fromJson(option))
              .toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'options': options
          .map((optionList) => optionList.map((o) => o.toJson()).toList())
          .toList(),
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
