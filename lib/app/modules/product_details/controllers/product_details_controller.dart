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
  var selectedQuantity = 1.obs;
  var price = 0.0.obs;
  var filteredVolumePrices = <VolumePrice>[].obs;

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
    selectedQuantity.value = 1;
    updatePriceAndQuantity();

    // Filter volume prices based on selected size
    final selectedVariation = product.value!.variations
        .firstWhere((variation) => variation.type == sizeType);
    filteredVolumePrices.value = product.value!.volumePrices
        .where((price) => price.productVariationId == selectedVariation.id)
        .toList();
  }

  // Method to select a color and update price and quantity based on color
  void selectColor(String colorName) {
    selectedColor.value = colorName;
    updatePriceAndQuantity();
  }

  void resetPriceToOriginal() {
    try {
      final sizeVariation = product.value!.variations
          .firstWhere((variation) => variation.type == selectedSize.value);
      final colorOption = sizeVariation.options
          .firstWhere((option) => option.name == selectedColor.value);

      price.value = colorOption.price; // Restore original price
    } catch (e) {
      price.value = 0.0; // Reset if no valid size or color is selected
    }
  }

  void applyVolumePricing() {
    if (filteredVolumePrices.isNotEmpty) {
      // Sort volume prices by quantity in descending order for easy checking
      filteredVolumePrices.sort((a, b) => b.quantity.compareTo(a.quantity));

      bool volumePriceApplied = false;

      for (var volumePrice in filteredVolumePrices) {
        if (selectedQuantity.value >= volumePrice.quantity) {
          price.value = double.parse(volumePrice.discountPrice);
          volumePriceApplied = true;
          break;
        }
      }

      // If no volume pricing is applied, reset to the original color option price
      if (!volumePriceApplied) {
        resetPriceToOriginal();
      }
    } else {
      resetPriceToOriginal();
    }
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

      // Apply volume pricing if applicable
      applyVolumePricing();
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

  void addToCart() {
    final selectedVariation = product.value!.variations.firstWhere(
      (variation) => variation.type == selectedSize.value,
    );
    final selectedOption = selectedVariation.options.firstWhereOrNull(
      (option) => option.name == selectedColor.value,
    );

    // Check if size and color are selected
    if (selectedOption == null || selectedQuantity.value == 0) {
      Get.snackbar("Selection Error", "Please select size and color",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Check stock availability
    int totalCartQuantity = Get.find<CartController>()
        .cartItems
        .where((item) =>
            item.productId == product.value!.id &&
            item.productVariationId == selectedVariation.id &&
            item.optionId == selectedOption.id)
        .fold(0, (sum, item) => sum + item.quantity);

    if (totalCartQuantity + selectedQuantity.value > selectedOption.quantity) {
      Get.snackbar("Stock Limit",
          "You cannot add more than ${selectedOption.quantity} of this item",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Create a CartItem with the selected product details
    CartItem cartItem = CartItem(
      productId: product.value!.id,
      productVariationId: selectedVariation.id,
      optionId: selectedOption.id,
      quantity: selectedQuantity.value,
      price: price.value,
      name: product.value!.name, // Adding the product name
      size: selectedSize.value, // Adding the selected size
      color: selectedColor.value, // Adding the selected color
      imageUrl: product.value!.images.isNotEmpty
          ? product.value!.images[
              selectedImageIndex.value] // Image URL for the selected image
          : '', // Fallback if no images
    );

    // Add item to cart
    Get.find<CartController>().addItem(cartItem);

    Get.snackbar("Success", "Item added to cart",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  void increaseQuantity() {
    final product = this.product.value;
    final selectedVariation = product?.variations.firstWhereOrNull(
      (variation) => variation.type == selectedSize.value,
    );

    final selectedOption = selectedVariation?.options.firstWhereOrNull(
      (option) => option.name == selectedColor.value,
    );

    // Check if the selected option has enough stock
    if (selectedOption != null &&
        selectedQuantity.value < selectedOption.quantity) {
      selectedQuantity.value++;
      applyVolumePricing(); // Update price based on new quantity
    } else {
      // Show snackbar if trying to exceed available stock
      Get.snackbar(
        "Stock Limit",
        "not_enough_stock".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void decreaseQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
      applyVolumePricing(); // Update price based on new quantity
    }
  }
}
