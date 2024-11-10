class Product {
  String? id;
  String? name;
  String? category;
  String? description;
  List<String>? images;
  List<ColorOption>? colors;
  String? brand;

  Product({
    this.id,
    this.name,
    this.category,
    this.description,
    this.images,
    this.brand,
    this.colors,
  });

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': images,
      'brand': brand,
      'category': category,
      'colors': colors?.map((colorOption) => colorOption.toMap()).toList(),
    };
  }

  // From JSON constructor
  factory Product.fromMap(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String?,
      colors: List<ColorOption>.from(
          json['colors']?.map((x) => ColorOption.fromMap(x)) ?? []),
      description: json['description'] as String?,
      category: json['category'] as String?,
      images: json['image'] != null ? List<String>.from(json['image']) : [],
      brand: json['brand'] as String?,
    );
  }
}

class ColorOption {
  String color;
  List<SizeOption> sizes;

  ColorOption({required this.color, required this.sizes});

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'sizes': sizes.map((size) => size.toMap()).toList(),
    };
  }

  factory ColorOption.fromMap(Map<String, dynamic> map) {
    return ColorOption(
      color: map['color'] ?? '',
      sizes: List<SizeOption>.from(
          map['sizes']?.map((x) => SizeOption.fromMap(x)) ?? []),
    );
  }
}

class SizeOption {
  String size;
  int quantity;
  int price;

  SizeOption({required this.size, required this.quantity, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }

  factory SizeOption.fromMap(Map<String, dynamic> map) {
    return SizeOption(
      size: map['size'] ?? "",
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
    );
  }
}
