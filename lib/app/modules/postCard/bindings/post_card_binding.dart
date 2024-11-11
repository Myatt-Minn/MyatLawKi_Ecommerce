import 'package:get/get.dart';

import '../controllers/post_card_controller.dart';

class PostCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostCardController>(
      () => PostCardController(),
    );
  }
}
