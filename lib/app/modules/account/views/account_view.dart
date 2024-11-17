import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstsConfig.primarycolor,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(
          'profile'.tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF693A36),
        actions: [
          TextButton(
            onPressed: controller.logout,
            child: Text(
              'logout'.tr,
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          // Profile Picture and Username
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: controller.currentUser.value != null &&
                                controller.currentUser.value!.image.isNotEmpty
                            ? NetworkImage(controller.currentUser.value!.image)
                            : AssetImage('assets/person.png'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.edit,
                              size: 16, color: Colors.black),
                          onPressed: () {
                            Get.toNamed('/edit-profile');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    controller.currentUser.value != null
                        ? controller.currentUser.value!.name
                        : "User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Options
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF512C2A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildMenuItem(Icons.access_time_outlined, 'order_history'.tr,
                    () async {
                  if (await controller.checkAndPromptLogin()) {
                    Get.toNamed('/order-history');
                  } else {
                    return;
                  }
                }),
                _buildMenuItem(Icons.favorite_border, 'favorites'.tr, () {
                  Get.toNamed('/wishlist');
                }),
                _buildMenuItem(Icons.lock_outline, 'change_password'.tr,
                    () async {
                  if (await controller.checkAndPromptLogin()) {
                    Get.toNamed('/forgot-password');
                  } else {
                    return;
                  }
                }),
                _buildMenuItem(Icons.headset_mic_outlined, 'contact_us'.tr, () {
                  Get.toNamed('/contact-us');
                }),
                _buildMenuItem(
                    Icons.description_outlined, 'terms_and_conditions'.tr, () {
                  controller.goToWebsite();
                }),
                _buildLanguageToggle(),
                const Divider(color: Colors.grey),
                // _buildDeleteAccount(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, void Function() fn) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: fn, // Call the function directly here
    );
  }

  Widget _buildLanguageToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'change_language'.tr,
            style: TextStyle(color: Colors.white),
          ),
          Obx(
            () => ToggleButtons(
              isSelected: [
                controller.selectedLanguage.value == 'ENG',
                controller.selectedLanguage.value == 'MYN'
              ],
              onPressed: (index) {
                final language = index == 0 ? 'ENG' : 'MYN';
                controller.toggleLanguage(language); // Call to change language
              },
              selectedColor: Colors.white,
              color: Colors.white,
              fillColor: Colors.black,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('ENG'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('MYN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return ListTile(
      title: Text(
        'delete_account'.tr,
        style: TextStyle(color: Colors.red),
      ),
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: Text('confirm_delete'.tr),
            content: Text('delete_account_warning'.tr),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text('cancel'.tr),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'delete'.tr,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
