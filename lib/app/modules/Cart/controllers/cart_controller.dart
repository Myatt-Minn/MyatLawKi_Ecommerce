import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myat_ecommerence/app/data/cart_model.dart';
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
  }

  void addItem(CartItem item) {
    // Check if item already exists in the cart
    var existingItemIndex = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.size == item.size &&
          cartItem.color == item.color,
    );

    if (existingItemIndex != -1) {
      // Item exists, increase quantity
      var existingItem = cartItems[existingItemIndex];
      if (existingItem.quantity + item.quantity <= item.stock) {
        cartItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
      } else {
        Get.snackbar(
          "Stock Limit",
          "You cannot add more than ${item.stock} of this item",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Add as a new item
      if (item.quantity <= item.stock) {
        cartItems.add(item);
      } else {
        Get.snackbar(
          "Stock Limit",
          "You cannot add more than ${item.stock} of this item",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    calculateTotalAmount();
    saveCartToStorage(); // Save to persistent storage
  }

  void calculateTotalAmount() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
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
        title: "Login First",
        content: Text('to_proceed'.tr),
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
      double itemTotal = (item.price * item.quantity);
      return sum + itemTotal;
    });
  }

  void saveCartToStorage() {
    List<Map<String, dynamic>> cartData = cartItems
        .map((item) =>
            item.toJson()) // Assuming you have a toJson method in CartItem
        .toList();
    storage.write('cart', cartData); // Save the cart to storage
  }

  void loadCartFromStorage() {
    List<dynamic> storedCart = storage.read<List<dynamic>>('cart') ?? [];
    cartItems.value = storedCart
        .map((item) =>
            CartItem.fromJson(item)) // Assuming you have a fromJson method
        .toList();
    updateTotalAmount();
  }
}
