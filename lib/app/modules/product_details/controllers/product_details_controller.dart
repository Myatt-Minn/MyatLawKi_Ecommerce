import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/cart_model.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  Rxn<Product> product = Rxn<Product>();
  RxInt selectedImageIndex = 0.obs;
  RxString selectedColor = ''.obs;
  var selectedSizeIndex = 0.obs;
  RxInt quantity = 0.obs;
  var selectedSize = ''.obs;
  var selectedquantity = 1.obs;
  var price = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    product.value = Get.arguments;
    selectedColor = product.value!.variations.first.options.first.name.obs;
  }

  void changeImage(int index) {
    selectedImageIndex.value =
        index; // Change the main image based on selected thumbnail
  }

// Method to select a size and update colors based on the size selected
  void selectSize(String sizeType) {
    selectedSize.value = sizeType;
    // Reset selected color when size is changed
    selectedColor.value = '';
    selectedquantity.value = 1;
    updatePriceAndQuantity(); // Set price and quantity for initial state
  }

  // Method to select a color and update price and quantity based on color
  void selectColor(String colorName) {
    selectedColor.value = colorName;
    updatePriceAndQuantity();
  }

  // Updates price and quantity based on selected size and color
  void updatePriceAndQuantity() {
    try {
      final sizeVariation = product.value!.variations
          .firstWhere((variation) => variation.type == selectedSize.value);
      final colorOption = sizeVariation.options
          .firstWhere((option) => option.name == selectedColor.value);

      price.value = colorOption.price;
      quantity.value = colorOption.quantity;
    } catch (e) {
      // If selected size or color is not found, reset price and quantity
      price.value = 0.0;
      quantity.value = 0;
    }
  }

  // Returns list of available colors for the selected size
  List<String> getAvailableColors() {
    try {
      final sizeVariation = product.value!.variations
          .firstWhere((variation) => variation.type == selectedSize.value);
      return sizeVariation.options.map((option) => option.name).toList();
    } catch (e) {
      return []; // Return empty list if size is not selected
    }
  }

  void chosenColor() {}
  // Decrease quantity
  void decreaseQuantity() {
    if (selectedquantity.value > 1) {
      selectedquantity.value--;
    }
  }

  void addToCart() {
    final selectedSize = product.value!.variations[selectedSizeIndex.value];
    final selectedOption = selectedSize.options.firstWhereOrNull(
      (option) => option.name == selectedColor.value,
    );

    // Check if size and color are selected
    if (selectedOption == null) {
      Get.snackbar("Selection Error", "Please select size and color",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Check stock availability
    if (selectedOption.quantity <= 0) {
      Get.snackbar("Out of Stock", "The selected option is out of stock",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Create a CartItem with the selected product details
    CartItem cartItem = CartItem(
      imageUrl: product.value!.images[0],
      productId: product.value!.id.toString(),
      name: product.value!.name,
      price: selectedOption.price,
      size: selectedSize.type,
      color: selectedOption.name,
      quantity: selectedquantity.value,
    );

    // Add item to cart
    Get.find<CartController>().addItem(cartItem);

    Get.snackbar("Success", "Item added to cart",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void increaseQuantity() {
    final product = this.product.value;
    final selectedSize = product?.variations[selectedSizeIndex.value];
    final selectedOption = selectedSize?.options.firstWhereOrNull(
      (option) => option.name == selectedColor.value,
    );

    // Check if the selected option has enough stock
    if (selectedOption != null && selectedquantity.value < quantity.value) {
      selectedquantity.value++;
    } else {
      // Show snackbar if trying to exceed available stock
      Get.snackbar("Stock Limit", "Cannot exceed available stock",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
