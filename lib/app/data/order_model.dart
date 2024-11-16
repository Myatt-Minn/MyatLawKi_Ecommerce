import 'package:myat_ecommerence/app/data/product_model.dart';

class Order {
  final int id;
  final int customerId;
  final String paymentMethod;
  final Payment? payment; // Nullable to handle empty payment
  final String? paymentPhoto;
  final String name;
  final String phone;
  final String region;
  final String city;
  final String address;
  final double deliveryFee;
  final double subTotal;
  final double grandTotal;
  final String? cancelMessage;
  final String? refundDate;
  final String? refundMessage;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.customerId,
    required this.paymentMethod,
    this.payment,
    this.paymentPhoto,
    required this.name,
    required this.phone,
    required this.region,
    required this.city,
    required this.address,
    required this.deliveryFee,
    required this.subTotal,
    required this.grandTotal,
    this.cancelMessage,
    this.refundDate,
    this.refundMessage,
    required this.status,
    required this.createdAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      paymentMethod: json['payment_method'],
      payment: json['payment'] is Map<String, dynamic>
          ? Payment.fromJson(json['payment'])
          : null,
      paymentPhoto: json['payment_photo'],
      name: json['name'],
      phone: json['phone'],
      region: json['region'],
      city: json['city'],
      address: json['address'],
      deliveryFee: double.parse(json['delivery_fee']),
      subTotal: double.parse(json['sub_total']),
      grandTotal: double.parse(json['grand_total']),
      cancelMessage: json['cancel_message']?.toString(),
      refundDate: json['refund_date']?.toString(),
      refundMessage: json['refund_message']?.toString(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      orderItems: (json['order_item'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'payment_method': paymentMethod,
      'payment': payment?.toJson(),
      'payment_photo': paymentPhoto,
      'name': name,
      'phone': phone,
      'region': region,
      'city': city,
      'address': address,
      'delivery_fee': deliveryFee,
      'sub_total': subTotal,
      'grand_total': grandTotal,
      'cancel_message': cancelMessage,
      'refund_date': refundDate,
      'refund_message': refundMessage,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'order_item': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String price;
  final String quantity;
  final String totalPrice;
  final DateTime? createdAt;
  final Product product;
  final OrderVariation orderVariation;
  final OrderVariationOption orderVariationOption;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    this.createdAt,
    required this.product,
    required this.orderVariation,
    required this.orderVariationOption,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: int.parse(json['order_id']),
      productId: int.parse(json['product_id']),
      price: json['price'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'] != null && json['created_at'].isNotEmpty
          ? DateTime.parse(json['created_at'])
          : null,
      product: Product.fromJson(json['product']),
      orderVariation: OrderVariation.fromJson(json['order_variation']),
      orderVariationOption:
          OrderVariationOption.fromJson(json['order_variation_option']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId.toString(),
      'product_id': productId.toString(),
      'price': price,
      'quantity': quantity,
      'total_price': totalPrice,
      'created_at': createdAt?.toIso8601String() ?? '',
      'product': product.toJson(),
      'order_variation': orderVariation.toJson(),
      'order_variation_option': orderVariationOption.toJson(),
    };
  }
}

class OrderVariation {
  final int id;
  final String name;

  OrderVariation({
    required this.id,
    required this.name,
  });

  factory OrderVariation.fromJson(Map<String, dynamic> json) {
    return OrderVariation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class OrderVariationOption {
  final int id;
  final String name;

  OrderVariationOption({
    required this.id,
    required this.name,
  });

  factory OrderVariationOption.fromJson(Map<String, dynamic> json) {
    return OrderVariationOption(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Payment {
  final int id;
  final String paymentLogo;
  final String paymentType;
  final String name;
  final String number;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.paymentLogo,
    required this.paymentType,
    required this.name,
    required this.number,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      paymentLogo: json['payment_logo'],
      paymentType: json['payment_type'],
      name: json['name'],
      number: json['number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_logo': paymentLogo,
      'payment_type': paymentType,
      'name': name,
      'number': number,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
