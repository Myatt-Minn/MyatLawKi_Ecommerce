import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/cart_model.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';

class CartItems extends StatelessWidget {
  final CartController cartController;

  const CartItems({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Item(s)',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white)),
          const SizedBox(height: 10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final CartItem item = cartController.cartItems[index];
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4)
                  ],
                ),
                child: Row(
                  children: [
                    Image.network(item.imageUrl,
                        width: 80, height: 80, fit: BoxFit.cover),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black)),
                        const SizedBox(height: 5),
                        Text('${item.price} MMK',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                        Row(
                          children: [
                            Text(
                              'Color: ${item.color}   ,',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 10),
                            Text('Size: ${item.size}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                        Text('Quantity: ${item.quantity}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
