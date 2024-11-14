import 'package:badges/badges.dart' as badges;
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';
import 'package:myat_ecommerence/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:myat_ecommerence/app/modules/product_details/controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController(), permanent: true);

    return Scaffold(
        backgroundColor: ConstsConfig.primarycolor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          title: Text('Detail', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.yellow),
              position: badges.BadgePosition.topEnd(top: -4, end: -4),
              badgeContent: Text(
                '0',
                style: TextStyle(color: Colors.black),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Get.find<NavigationScreenController>().currentIndex.value = 3;
                  Get.back();
                },
              ),
            ),
            SizedBox(
              width: 9.0,
            )
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Center(
                    child: FancyShimmerImage(
                      imageUrl: controller.product.value!.images.isNotEmpty
                          ? controller.product.value!
                              .images[controller.selectedImageIndex.value]
                          : '', // Display selected image based on index
                      height: 180,
                      width: 180,
                      boxFit: BoxFit.contain,
                      boxDecoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.product.value!.images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.changeImage(
                                index); // Update the selected image index
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    controller.selectedImageIndex.value == index
                                        ? ConstsConfig.secondarycolor
                                        : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FancyShimmerImage(
                              imageUrl: controller.product.value!.images[index],
                              width: 70,
                              height: 70,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.product.value!
                            .name, // Replace with actual product name
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        controller.quantity.value == 0
                            ? "Choose size and color"
                            : "${controller.quantity.value} in Stock",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Obx(
                  () => Text(
                    controller.product.value!
                        .category, // Replace with actual product name
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38),
                  ),
                ),
                Obx(
                  () => Text(
                    "${controller.price.value} MMK", // Replace with actual price
                    style: TextStyle(fontSize: 16, color: Colors.yellow),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Available Size:",
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        const SizedBox(height: 5),
                        Obx(
                          () => DropdownButton<String>(
                            dropdownColor: ConstsConfig.primarycolor,
                            style: const TextStyle(color: Colors.white),
                            value: controller.selectedSize.value.isEmpty
                                ? null
                                : controller.selectedSize.value,
                            items: controller.product.value!.variations
                                .map(
                                  (variation) => DropdownMenuItem<String>(
                                    value: variation.type,
                                    child: Text(variation.type),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectSize(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Color:",
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        SizedBox(
                          height: 9,
                        ),
                        Obx(
                          () {
                            final colorOptions =
                                controller.getAvailableColors();
                            return DropdownButton<String>(
                              dropdownColor: ConstsConfig.primarycolor,
                              style: const TextStyle(color: Colors.white),
                              value: controller.selectedColor.value.isEmpty
                                  ? null
                                  : controller.selectedColor.value,
                              items: colorOptions
                                  .map((color) => DropdownMenuItem<String>(
                                        value: color,
                                        child: Text(color),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.selectColor(value);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Whole sale/retail",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      Column(
                        children:
                            controller.product.value!.volumePrices.isNotEmpty
                                ? controller.product.value!.volumePrices
                                    .map((price) {
                                    return Text(
                                      "${price.quantity} Quantity - ${price.discountPrice} Ks",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    );
                                  }).toList()
                                : [
                                    Text(
                                      "0 Quantity - 0 MMK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Product description",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    controller.product.value!.description,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.black),
                    onPressed: () {
                      controller.decreaseQuantity();
                    },
                  ),
                ),
                Obx(
                  () => Container(
                    width: 60,
                    height: 50,
                    color: ConstsConfig.secondarycolor,
                    child: Center(
                      child: Text(
                        controller.selectedquantity.value
                            .toString(), // Quantity
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      controller.increaseQuantity();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.15),
                    ),
                    onPressed: () {
                      controller.addToCart();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_bag, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
