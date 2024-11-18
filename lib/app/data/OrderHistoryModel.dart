import 'package:myat_ecommerence/app/data/payment_model.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';

class OrderHistoryModel {
  bool? success;
  String? message;
  List<OrderHistoryData>? data;

  OrderHistoryModel({this.success, this.message, this.data});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderHistoryData>[];
      json['data'].forEach((v) {
        data!.add(OrderHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderHistoryData {
  int? id;
  int? customerId;
  String? paymentMethod;
  int? paymentId;
  String? paymentPhoto;
  String? name;
  String? phone;
  String? region;
  String? city;
  String? address;
  String? deliveryFee;
  String? subTotal;
  String? grandTotal;
  String? cancelMessage;
  String? refundDate;
  String? refundMessage;
  String? status;
  String? createdAt;
  List<OrderItem>? orderItem;
  PaymentModel? payment;

  OrderHistoryData(
      {this.id,
      this.customerId,
      this.paymentMethod,
      this.paymentId,
      this.paymentPhoto,
      this.name,
      this.phone,
      this.region,
      this.city,
      this.address,
      this.deliveryFee,
      this.subTotal,
      this.grandTotal,
      this.cancelMessage,
      this.refundDate,
      this.refundMessage,
      this.status,
      this.createdAt,
      this.orderItem,
      this.payment});

  OrderHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    paymentMethod = json['payment_method'];
    paymentId = json['payment_id'];
    paymentPhoto = json['payment_photo'];
    name = json['name'];
    phone = json['phone'];
    region = json['region'];
    city = json['city'];
    address = json['address'];
    deliveryFee = json['delivery_fee'];
    subTotal = json['sub_total'];
    grandTotal = json['grand_total'];
    cancelMessage = json['cancel_message'];
    refundDate = json['refund_date'];
    refundMessage = json['refund_message'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['order_item'] != null) {
      orderItem = <OrderItem>[];
      json['order_item'].forEach((v) {
        orderItem!.add(OrderItem.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_id'] = paymentId;
    data['payment_photo'] = paymentPhoto;
    data['name'] = name;
    data['phone'] = phone;
    data['region'] = region;
    data['city'] = city;
    data['address'] = address;
    data['delivery_fee'] = deliveryFee;
    data['sub_total'] = subTotal;
    data['grand_total'] = grandTotal;
    data['cancel_message'] = cancelMessage;
    data['refund_date'] = refundDate;
    data['refund_message'] = refundMessage;
    data['status'] = status;
    data['created_at'] = createdAt;
    if (orderItem != null) {
      data['order_item'] = orderItem!.map((v) => v.toJson()).toList();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    return data;
  }
}

class OrderItem {
  int? id;
  String? orderId;
  String? productId;
  String? price;
  String? quantity;
  String? totalPrice;
  String? createdAt;
  Product? product;
  List<Variation>? orderVariation;
  VariationOption? orderVariationOption;

  OrderItem(
      {this.id,
      this.orderId,
      this.productId,
      this.price,
      this.quantity,
      this.totalPrice,
      this.createdAt,
      this.product,
      this.orderVariation,
      this.orderVariationOption});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['order_variation'] != null) {
      orderVariation = <Variation>[];
      json['order_variation'].forEach((v) {
        orderVariation!.add(Variation.fromJson(v));
      });
    }
    orderVariationOption = json['order_variation_option'] != null
        ? VariationOption.fromJson(json['order_variation_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (orderVariation != null) {
      data['order_variation'] = orderVariation!.map((v) => v.toJson()).toList();
    }
    if (orderVariationOption != null) {
      data['order_variation_option'] = orderVariationOption!.toJson();
    }
    return data;
  }
}
