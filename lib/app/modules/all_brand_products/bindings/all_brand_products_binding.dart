import 'package:get/get.dart';

import '../controllers/all_brand_products_controller.dart';

class AllBrandProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllBrandProductsController>(
      () => AllBrandProductsController(),
    );
  }
}
