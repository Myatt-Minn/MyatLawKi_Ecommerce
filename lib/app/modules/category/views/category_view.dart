import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/category/controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstsConfig.primarycolor,
      appBar: AppBar(
        title: const Text(
          'Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category and Brand Tabs
          Container(
            color: const Color(0xFF693A36), // Brown background color
            child: Row(
              children: [
                _buildTab('categories'.tr),
                _buildTab('brands'.tr),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Obx(() {
              if (controller.selectedCategory.value == 'Categories' ||
                  controller.selectedCategory.value == 'အမျိုးအစားများ') {
                return _buildCategoryGrid();
              } else {
                return _buildBrandGrid();
              }
            }),
          ),
        ],
      ),
    );
  }

  // Tab button widget (Categories / Brands)
  Widget _buildTab(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedCategory.value = label;
        },
        child: Obx(
          () => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: controller.selectedCategory.value == label
                  ? const Color(0xFF693A36)
                  : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: controller.selectedCategory.value == label
                      ? Colors.white
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: controller.selectedCategory.value == label
                    ? Colors.white
                    : Colors.grey.shade300,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Categories Grid
  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.categories.map((category) {
        return GestureDetector(
          onTap: () {
            Get.toNamed('/all-category-products', arguments: category.title);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.brown,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Brands Grid (replace with actual data if available)
  Widget _buildBrandGrid() {
    // Dummy brands list
    final brands = ['Brand A', 'Brand B', 'Brand C'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: brands.map((brand) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            brand,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.brown,
            ),
          ),
        );
      }).toList(),
    );
  }
}
