import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';

class AllProductsController extends GetxController {
  RxList<Product> products = <Product>[].obs; // List of all products
  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxList<SizeOption> sizeList = <SizeOption>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      products.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return Product.fromMap(data);
      }).toList();

      isLoading.value = false;
      filteredProducts.assignAll(products);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }

  void displayProductSizes(Product product) {
    for (var colorOption in product.colors!) {
      for (var sizeOption in colorOption.sizes) {
        sizeList.add(sizeOption);
      }
    }
  }

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
