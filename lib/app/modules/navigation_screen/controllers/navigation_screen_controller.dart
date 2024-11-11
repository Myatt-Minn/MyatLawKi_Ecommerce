import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/sendNotificationHandler.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';
import 'package:myat_ecommerence/app/modules/account/controllers/account_controller.dart';
import 'package:myat_ecommerence/app/modules/category/controllers/category_controller.dart';
import 'package:myat_ecommerence/app/modules/home/controllers/home_controller.dart';
import 'package:myat_ecommerence/app/modules/notification/controllers/notification_controller.dart';
import 'package:myat_ecommerence/app/modules/productCard/controllers/product_card_controller.dart';

class NavigationScreenController extends GetxController {
  //TODO: Implement NavigationScreenController
  var currentIndex = 0.obs;
  var gg = "";

  @override
  void onInit() async {
    super.onInit();
    initializeController(currentIndex.value);
    await SendNotificationHandler().initNotification();
  }

  void initializeController(int index) {
    // Initialize the corresponding controller based on the selected index
    switch (index) {
      case 0:
        Get.put(FeedsController());
        Get.put(ProductCardController(), permanent: true);
        break;
      case 1:
        Get.put(HomeController());
        break;
      case 2:
        Get.put(CategoryController());
        break;
      case 3:
        Get.put(CartController());
        break;
      case 4:
        Get.put(AccountController());
        break;
    }
  }

  void disposeController(int index) {
    // Delete the controller from memory when navigating away
    switch (index) {
      case 0:
        Get.delete<FeedsController>();
        break;
      case 1:
        Get.delete<HomeController>();
        Get.delete<NotificationController>();
        break;
      case 2:
        Get.delete<CategoryController>();
        break;
    }
  }
}
