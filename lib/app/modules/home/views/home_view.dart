import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:myat_ecommerence/app/modules/notification/controllers/notification_controller.dart';
import 'package:myat_ecommerence/app/modules/productCard/views/product_card_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstsConfig.primarycolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // App bar with logo and notification icon
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo.png', // Add your app logo here
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ecommerce App",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              ConstsConfig.appname,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(() => Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.toNamed('/notification');
                              },
                            ),
                            if (Get.find<NotificationController>().itemCount >
                                0) // Show badge only if there are items
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/notification');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${Get.find<NotificationController>().itemCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/all-products');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Same fill color
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.black,
                        ), // Search Icon
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${'search'.tr} / ${'filter'.tr}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16), // Hint text styling
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            Get.toNamed('/all-products');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(() {
                if (controller.banners.isEmpty) {
                  return const CircularProgressIndicator(); // Show loading indicator while banners load
                }

                return SizedBox(
                  height: 180,
                  child: PageView.builder(
                    onPageChanged: controller.changePage,
                    controller: controller
                        .pageController, // Use the PageController from the controller
                    itemCount: controller.banners.length,
                    itemBuilder: (context, index) {
                      return FancyShimmerImage(
                        imageUrl: controller.banners[index].imgUrl,
                        boxFit: BoxFit.cover,
                        height: 160,
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Dots Indicator
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.banners
                          .length, // Generate dots based on the number of banners
                      (index) =>
                          buildDot(index, controller.currentBanner.value),
                    ),
                  )),

              const SizedBox(height: 10),
              // Category Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "categories".tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.find<NavigationScreenController>()
                            .currentIndex
                            .value = 2;
                      },
                      child: Text(
                        "${'see_all'.tr} >",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Adjusted Category ListView with Proper Height
              Obx(
                () => SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (builder, index) {
                      return _buildCategoryIcon(
                          controller.categories[index].title);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // New Arrivals Section
              buildSectionHeader("all_products".tr, () {
                Get.toNamed('all-products');
              }),
              Obx(() {
                return controller.productList.isEmpty
                    ? Center(
                        child: Text("no_products".tr),
                      )
                    : GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling for the GridView
                        shrinkWrap:
                            true, // Allows GridView to take as much space as needed
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: controller.productList.length,
                        itemBuilder: (context, index) {
                          final product = controller.productList[index];
                          controller.displayProductSizes(product);
                          return ProductCardView(
                            product: product,
                            sizeOptions: controller.sizeList,
                          );
                        },
                      );
              }),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

// Build the section header with "See all"
  Widget buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text(
                  "see_all".tr,
                  style: TextStyle(color: Colors.blue),
                ),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for building category icon widgets
  Widget _buildCategoryIcon(String name) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/all-category-products', arguments: name);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ))),
    );
  }

  // Dot builder for the page indicator
  Widget buildDot(int index, int currentPage) {
    return Container(
      height: 10.0,
      width: currentPage == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
    );
  }
}
