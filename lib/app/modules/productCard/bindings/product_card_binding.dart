import 'package:get/get.dart';

import '../controllers/product_card_controller.dart';

class ProductCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductCardController());
  }
}
