import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/brand_model.dart';
import 'package:myat_ecommerence/app/data/category_model.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';

class CategoryController extends GetxController {
  var selectedCategory = 'Categories'.obs; // Observable for category selection
  var searchText = ''.obs; // Observable for search input
  var isFavorite = false.obs;
  var brands = <BrandModel>[].obs;
  var categories = <CategoryModel>[].obs;
  RxList<Product> productList = <Product>[].obs; // Observable list of products
  RxList<Product> productsByBrand = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller initializes
    getProductsByBrand('Nike');
    fetchBrands();
    fetchCategories();
  }

  // Fetch brands from Firestore
  Future<void> fetchBrands() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('brand').get();
      brands.value = snapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories.value = snapshot.docs
          .map((doc) =>
              CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }

  // Fetch products from Firestore where the 'category' field matches the provided category value
  Future<void> fetchProducts({String category = 'shoe'}) async {
    try {
      // Query the 'products' collection where the 'category' field matches the provided value
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(
              'new_arrivals') // Assuming the collection is named 'products'
          .where('category', isEqualTo: category) // Filter by category field
          .get();

      // Map Firestore data to the Product model
      productList.value = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }

  Future<void> getProductsByBrand(String brand) async {
    try {
      // Query Firestore to retrieve products where 'brand' matches the provided brand
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .where('brand', isEqualTo: brand)
          .get();

      // Map Firestore documents to Product objects and update the RxList
      productsByBrand.value = querySnapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }

  // Add to cart
  void addToCart(Product product) {
    Get.snackbar('Cart', '${product.name} added to cart!');
  }

  // Filtered products based on search query
  List<Product> get filteredProducts {
    if (searchText.isEmpty) {
      return productList;
    } else {
      return productList
          .where((product) =>
              product.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              product.category!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }
  }

  // Filtered products based on search query
  List<Product> get filteredBrand {
    if (searchText.isEmpty) {
      return productsByBrand;
    } else {
      return productsByBrand
          .where((product) =>
              product.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              product.brand!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }
}
