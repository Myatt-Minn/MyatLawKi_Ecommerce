import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/modules/wishlist/controllers/wishlist_controller.dart';

class SavedProductCard extends GetView<WishlistController> {
  final Product product;
  final List<SizeOption> sizeOptions;

  const SavedProductCard({
    super.key,
    required this.product,
    required this.sizeOptions,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.savedStatusMap.containsKey(product.id)) {
      controller.checkIfSaved(product);
    }
    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: FancyShimmerImage(
                    imageUrl: product.images![0],
                    width: double.infinity,
                    height: 120,
                    boxFit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() => IconButton(
                        icon: Icon(
                          controller.savedStatusMap[product.id]?.value == true
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.purple,
                          size: 28,
                        ),
                        onPressed: () => controller.toggleSaveStatus(product),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand!,
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${sizeOptions[0].price} MMK",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}