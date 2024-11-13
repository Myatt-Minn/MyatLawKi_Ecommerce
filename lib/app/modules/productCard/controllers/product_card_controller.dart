import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductCardController extends GetxController {
  //TODO: Implement ProductCardController

  // final userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, RxBool> savedStatusMap = <String, RxBool>{}.obs;

  // Future<void> toggleSaveStatus(Product product) async {
  //   try {
  //     final userDocRef = _firestore.collection('users').doc(userId);
  //     final postRef =
  //         userDocRef.collection('savedProducts').doc(product.id.toString());

  //     if (savedStatusMap[product.id]?.value ?? false) {
  //       // Remove if already saved
  //       await postRef.delete();
  //       savedStatusMap[product.id]?.value = false;
  //       Get.snackbar("Removed", "Product removed to Wishlist",
  //           backgroundColor: ConstsConfig.secondarycolor);
  //     } else {
  //       // Save post data if not already saved
  //       await postRef.set(product.toJson());
  //       savedStatusMap[product.id!.toString()] = true.obs;
  //       Get.snackbar("Saved", "Product saved to Wishlist",
  //           backgroundColor: ConstsConfig.secondarycolor);
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
}
