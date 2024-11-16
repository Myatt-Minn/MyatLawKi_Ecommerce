import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/order_model.dart';

class OrderDetails extends StatelessWidget {
  final Order order = Get.arguments;

  OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstsConfig.primarycolor,
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 16),
            _buildItemDetails(),
            const SizedBox(height: 16),
            _buildPaymentType(),
            const SizedBox(height: 16),
            _buildTransitionImage(),
            const SizedBox(height: 16),
            _buildCustomerInfo(),
            const SizedBox(height: 16),
            _buildCostDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order.id}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Total Price",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              "${order.grandTotal} MMK",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Status: ${order.status}",
              style: const TextStyle(fontSize: 16, color: Colors.yellow),
            ),
            const SizedBox(height: 5),
            Text(
              "Order Date: ${DateFormat('yyyy-MM-dd').format(order.createdAt)}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: order.orderItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 50,
                  color: Colors.grey,
                  child: Image.network(
                    item.product.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Price: ${item.price} MMK",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      "Size: ${item.orderVariation.name}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentType() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Payment Type: ${order.paymentMethod}",
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildTransitionImage() {
    return order.payment != null
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Transition Image",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Image.network(
                  order.paymentPhoto!,
                  height: 100,
                  fit: BoxFit.cover,
                )
              ],
            ))
        : Container();
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Name: ${order.name}"),
          const SizedBox(height: 8),
          Text("Phone Number: ${order.phone}"),
          const SizedBox(height: 8),
          Text("Address: ${order.address}, ${order.city}, ${order.region}"),
        ],
      ),
    );
  }

  Widget _buildCostDetails() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            "Subtotal",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          trailing: Text(
            "${order.subTotal} MMK",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        ListTile(
          title: const Text(
            "Delivery Fees",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          trailing: Text(
            "${order.deliveryFee} MMK",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text(
            "Total Cost",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          trailing: Text(
            "${order.grandTotal} MMK",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
