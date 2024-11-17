import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/notification/controllers/notification_controller.dart';
import 'package:myat_ecommerence/app/modules/postCard/controllers/post_card_controller.dart';
import 'package:myat_ecommerence/app/modules/postCard/views/post_card_view.dart';

import '../controllers/feeds_controller.dart';

class FeedsView extends GetView<FeedsController> {
  const FeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PostCardController());
    return Scaffold(
      backgroundColor:
          ConstsConfig.primarycolor, // Set the brown background color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            const Color(0xFF5D3A2D), // Same color as the background
        leading: Image.asset(
          'assets/icon.png', // Replace with your logo image path
          height: 50,
        ),
        title: Text(
          "မြတ် - လောကီအစီအရင်များ".tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.checkLogin();
                    },
                  ),
                  if (Get.find<NotificationController>().itemCount >
                      0) // Show badge only if there are items
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/notification');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${Get.find<NotificationController>().itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search By Product Name',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.filter_list),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          Expanded(child: Obx(() {
            return controller.posts.isEmpty && controller.posts.isNotEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: controller.posts.length,
                    itemBuilder: (context, index) {
                      var postData = controller.posts[index];
                      return PostCardView(
                        post: postData,
                      );
                    },
                  );
          })),
        ],
      ),
    );
  }
}
