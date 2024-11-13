import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/modules/wishlist/views/widgets/saved_product_card.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wishlist'.tr),
      ),
      backgroundColor: ConstsConfig.primarycolor,
      body: Column(
        children: [
          // GridView to show products
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  Product product = controller.products[index];
                  // controller.displayProductSizes(product);
                  return SavedProductCard(
                    product: product,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
