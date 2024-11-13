import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';

class WishlistController extends GetxController {
  //TODO: Implement WishlistController
//TODO: Implement SavedproductsController

  RxList<Product> products = <Product>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, RxBool> savedStatusMap = <String, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchproducts();
  }

  // Future<void> fetchproducts() async {
  //   try {
  //     final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('savedProducts')
  //         .get();

  //     // Convert each document into a BlogModel
  //     List<Product> fetchproducts = snapshot.docs.map((doc) {
  //       return Product.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     products.value = fetchproducts;
  //   } catch (e) {
  //     print('Error fetching saved products: $e');
  //   }
  // }

  // void displayProductSizes(Product product) {
  //   for (var colorOption in product.colors!) {
  //     for (var sizeOption in colorOption.sizes) {
  //       sizeList.add(sizeOption);
  //     }
  //   }
  // }

  // Future<void> toggleSaveStatus(Product product) async {
  //   try {
  //     final userDocRef = _firestore.collection('users').doc(userId);
  //     final postRef =
  //         userDocRef.collection('savedProducts').doc(product.id.toString());

  //     if (savedStatusMap[product.id]?.value ?? false) {
  //       // Remove if already saved
  //       await postRef.delete();
  //       savedStatusMap[product.id]?.value = false;
  //     } else {
  //       // Save post data if not already saved
  //       await postRef.set(product.toJson());
  //       savedStatusMap[product.id!.toString()] = true.obs;
  //     }
  //   } catch (e) {
  //     print('Error saving post: $e');
  //   }
  // }

  // Future<void> checkIfSaved(Product product) async {
  //   final productRef = _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('savedProducts')
  //       .doc(product.id.toString());
  //   final doc = await productRef.get();
  //   savedStatusMap[product.id!.toString()] = RxBool(doc.exists);
  // }

  // Future<void> toggleSaveStatus(Product product) async {
  //   try {
  //     final userDocRef = _firestore.collection('users').doc(userId);
  //     final postRef = userDocRef.collection('savedProducts').doc(product.id);

  //     if (savedStatusMap[product.id]?.value ?? false) {
  //       // Remove if already saved
  //       await postRef.delete();
  //       savedStatusMap[product.id]?.value = false;
  //     } else {
  //       // Save post data if not already saved
  //       await postRef.set(product.toJson());
  //       savedStatusMap[product.id!] = true.obs;
  //     }
  //   } catch (e) {
  //     print('Error saving post: $e');
  //   }
  // }

  // Future<void> checkIfSaved(Product product) async {
  //   final productRef = _firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('savedProducts')
  //       .doc(product.id);
  //   final doc = await productRef.get();
  //   savedStatusMap[product.id!] = RxBool(doc.exists);
  // }
}
