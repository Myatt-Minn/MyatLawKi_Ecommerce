import 'package:badges/badges.dart' as badges;
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/app_widgets.dart';
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                color: ConstsConfig.primarycolor, // Icon background color
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
        ),
        title: Text('details'.tr),
        actions: [
          // Cart icon with badge
          Obx(() => Stack(
                clipBehavior: Clip.none, // Allow elements to overflow the stack
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ConstsConfig.primarycolor, // Icon background color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      onPressed: () {
                        Get.find<NavigationScreenController>()
                            .currentIndex
                            .value = 3;

                        Get.back();
                      },
                    ),
                  ),
                  if (cartController.itemCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: badges.Badge(
                        badgeContent: Text(
                          '${cartController.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        showBadge: cartController.itemCount > 0,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.red,
                          padding: const EdgeInsets.all(4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              )),

          SizedBox(
            width: 4,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Product Image
            Obx(() => Center(
                  child: FancyShimmerImage(
                    imageUrl: controller.product.value
                        .images![controller.selectedImageIndex.value],
                    height: 180,
                    width: 250,
                    boxFit: BoxFit.contain,
                  ),
                )),
            const SizedBox(height: 10),
            // Thumbnail Images (Carousel)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.product.value.images!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changeImage(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Obx(() => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.selectedImageIndex.value ==
                                          index
                                      ? ConstsConfig.secondarycolor
                                      : Colors.transparent,
                                  width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FancyShimmerImage(
                              imageUrl: controller.product.value.images![index],
                              width: 70,
                              height: 70,
                              boxFit: BoxFit.contain,
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Product Name
            Text(controller.product.value.name!,
                style: AppWidgets.smallboldlineTextFieldStyle()),
            const SizedBox(height: 5),
            // Product Description
            Text(controller.product.value.description!,
                style: AppWidgets.lightTextFieldStyle()),
            const SizedBox(height: 20),
            // Color Options
            Text("color".tr, style: AppWidgets.smallboldlineTextFieldStyle()),
            const SizedBox(height: 5),
            Obx(() => Row(
                  children: controller.colorOptions.map((colorOption) {
                    return GestureDetector(
                      onTap: () => controller.selectColor(colorOption.color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: controller.getColorFromName(colorOption.color),
                          shape: BoxShape.circle,
                          border: controller.selectedColor.value ==
                                  colorOption.color
                              ? Border.all(color: Colors.blueAccent, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 20),
            // Size Selection
            Text("available_sizes".tr,
                style: AppWidgets.smallboldlineTextFieldStyle()),
            const SizedBox(height: 5),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.sizeList.length,
                  itemBuilder: (context, index) {
                    final size = controller.sizeList[index];
                    return GestureDetector(
                      onTap: () {
                        if (size.quantity > 0) {
                          controller.selectSize(size.size);
                        } else {
                          Get.snackbar(
                              "Out of Stock", "This size is out of stock.",
                              backgroundColor: Colors.red,
                              colorText: Colors.black);
                        }
                      },
                      child: Obx(() {
                        final isSelected =
                            controller.selectedSize.value == size.size;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? ConstsConfig.secondarycolor
                                  : Colors.white,
                            ),
                            child: ListTile(
                              title: Text('${'size'.tr}: ${size.size}',
                                  style: const TextStyle(color: Colors.black)),
                              subtitle: Text('${'price'.tr}: ${size.price} Ks',
                                  style: const TextStyle(color: Colors.black)),
                              trailing: Text(
                                  '${'in_stock'.tr}: ${size.quantity}',
                                  style: const TextStyle(color: Colors.black)),
                              leading: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.radio_button_unchecked,
                                      color: Colors.black),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                )),
            const SizedBox(height: 10),
            // Quantity and Add to Cart
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  onPressed: controller.decreaseQuantity,
                ),
                Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration:
                        BoxDecoration(color: ConstsConfig.secondarycolor),
                    child: Text(controller.quantity.toString()))),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: controller.increaseQuantity,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstsConfig.secondarycolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (controller.selectedSize.value.isNotEmpty) {
                        controller.addToCart();
                      } else {
                        Get.snackbar("Error", "select_item".tr,
                            backgroundColor: Colors.red,
                            colorText: Colors.black);
                      }
                    },
                    child: Text('add_to_cart'.tr,
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
