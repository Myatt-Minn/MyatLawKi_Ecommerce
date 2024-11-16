import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/order_model.dart';

class OrderHistoryTile extends StatelessWidget {
  final Order order;

  const OrderHistoryTile({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirm':
        return Colors.green;
      case 'refund':
        return Colors.blue;
      case 'cancel':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Get.isDarkMode ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      title: Text(
        'Order ID: ${order.id}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            'Total Price: \$${order.grandTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            'Date: ${order.createdAt.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            order.status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(order.status),
            ),
          ),
          const SizedBox(height: 10),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
      onTap: () {
        // Navigate to the order details screen with the order object
        Get.toNamed('/order-history-detail', arguments: order);
      },
    );
  }
}
