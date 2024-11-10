import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/global_widgets/postCard.dart';

import '../controllers/feeds_controller.dart';

class FeedsView extends GetView<FeedsController> {
  const FeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ConstsConfig.primarycolor, // Set the brown background color
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF5D3A2D), // Same color as the background
        title: Image.asset(
          'assets/logo.png', // Replace with your logo image path
          height: 50,
        ),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1', // Change as needed
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
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
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  var postData = controller.posts[index];

                  return PostCard(
                    post: postData,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
