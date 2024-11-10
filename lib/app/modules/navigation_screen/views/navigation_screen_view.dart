import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/modules/Cart/views/cart_view.dart';
import 'package:myat_ecommerence/app/modules/Feeds/views/feeds_view.dart';
import 'package:myat_ecommerence/app/modules/account/views/account_view.dart';
import 'package:myat_ecommerence/app/modules/category/views/category_view.dart';
import 'package:myat_ecommerence/app/modules/home/views/home_view.dart';

import '../controllers/navigation_screen_controller.dart';

class NavigationScreenView extends GetView<NavigationScreenController> {
  final List<Widget> _views = [
    const FeedsView(),
    const HomeView(),
    const CategoryView(),
    const CartView(),
    const AccountView(),
  ];

  NavigationScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
          _views[controller.currentIndex.value]), // Display the current view
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.currentIndex.value = index;
            // Dispose of the old controller
            controller.disposeController(controller.currentIndex.value);

            // Initialize the new controller
            controller.initializeController(index);
          },
          backgroundColor: const Color(0xFFDFCFC7), // light beige color
          selectedItemColor:
              const Color(0xFF693A36), // brown color for selected item
          unselectedItemColor: const Color(0xFF693A36)
              .withOpacity(0.6), // faded brown for unselected items
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'စာမျက်နှာ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'ပစ္စည်းများ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'အမျိုးအစား',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'ဝယ်ယူခြင်း',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'မှတ်တမ်း',
            ),
          ],
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
