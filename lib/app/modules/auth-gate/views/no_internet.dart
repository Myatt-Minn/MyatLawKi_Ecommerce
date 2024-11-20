import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/modules/auth-gate/controllers/auth_gate_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthGateController controller = Get.find<AuthGateController>();
    return Scaffold(
        appBar: AppBar(
          title: Text('no_connection'.tr),
          centerTitle: true,
        ),
        backgroundColor: ConstsConfig.primarycolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/noInter.png', height: 200),
              const SizedBox(height: 20),
              const Text(
                'You are not connected to the internet.',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    controller.retryConnection();
                  },
                  child: Obx(() => (controller.isLoading.value)
                      ? const CircularProgressIndicator()
                      : const Text('Try Again'))),
            ],
          ),
        ));
  }
}
