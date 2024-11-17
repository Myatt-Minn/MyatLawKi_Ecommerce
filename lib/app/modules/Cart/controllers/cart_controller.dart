import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myat_ecommerence/app/data/cart_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;
  final storage = GetStorage();

  // Getter for cart item count
  int get itemCount => cartItems.length;

  @override
  void onInit() {
    super.onInit();
    cartItems
        .listen((_) => calculateTotalAmount()); // Recalculate when cart changes
    loadCartFromStorage(); // Load cart from storage on initialization
  }

  void addItem(CartItem item) {
    // Check if item already exists in the cart
    var existingItemIndex = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.productVariationId == item.productVariationId &&
          cartItem.optionId == item.optionId,
    );

    if (existingItemIndex != -1) {
      // Item exists, increase quantity
      var existingItem = cartItems[existingItemIndex];
      cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity! + item.quantity!,
      );
    } else {
      // Add as a new item
      cartItems.add(item);
    }

    calculateTotalAmount();
    saveCartToStorage(); // Save to persistent storage
  }

  void calculateTotalAmount() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity!;
    }
    totalAmount.value = total;
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
    calculateTotalAmount();
    saveCartToStorage(); // Save to persistent storage
  }

  void clearCart() {
    cartItems.clear();
    calculateTotalAmount();
    saveCartToStorage();
  }

  void checkAndPromptLogin() async {
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      Get.defaultDialog(
        title: "login_first".tr,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ConstsConfig.primarycolor,
        confirmTextColor: Colors.black,
        buttonColor: Colors.white,
        content: Text(
          'to_proceed'.tr,
          style: TextStyle(color: Colors.white),
        ),
        textConfirm: "OK",
        onConfirm: () {
          Get.offNamed('/login'); // Navigate to the login screen
        },
      );
    } else {
      // Proceed to checkout if logged in
      Get.toNamed('/check-out');
    }
  }

  // Update the total amount
  void updateTotalAmount() {
    totalAmount.value = cartItems.fold<double>(0, (sum, item) {
      double itemTotal = (item.price * item.quantity!);
      return sum + itemTotal;
    });
  }

  void saveCartToStorage() {
    List<Map<String, dynamic>> cartData = cartItems
        .map((item) =>
            item.toMap()) // Assuming you have a toMap method in CartItem
        .toList();
    storage.write('cart', cartData); // Save the cart to storage
  }

  void loadCartFromStorage() {
    List<dynamic> storedCart = storage.read<List<dynamic>>('cart') ?? [];
    cartItems.value = storedCart
        .map((item) =>
            CartItem.fromMap(item)) // Assuming you have a fromMap method
        .toList();
    updateTotalAmount();
  }
}
