import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';

class AllCategoryProductsController extends GetxController {
  //TODO: Implement AllCategoryProductsController

  RxList<Product> products = <Product>[].obs; // List of all products

  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxString? categorygg = ''.obs;
  @override
  void onInit() {
    super.onInit();
    categorygg!.value = Get.arguments;
    // fetchProducts(category: categorygg!.value);
  }

  // void displayProductSizes(Product product) {
  //   for (var colorOption in product.colors!) {
  //     for (var sizeOption in colorOption.sizes) {
  //       sizeList.add(sizeOption);
  //     }
  //   }
  // }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where((product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()) ||
                product.brand!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}
