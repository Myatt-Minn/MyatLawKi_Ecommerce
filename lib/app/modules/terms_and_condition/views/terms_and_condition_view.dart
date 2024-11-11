import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';

import '../controllers/terms_and_condition_controller.dart';

class TermsAndConditionView extends GetView<TermsAndConditionController> {
  const TermsAndConditionView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstsConfig.primarycolor,
      appBar: AppBar(
        title: Text('terms_and_conditions'.tr),
        centerTitle: true,
      ),
      body: FutureBuilder<String?>(
        future: controller.fetchTermsConditions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading Terms and Conditions'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No Terms and Conditions available.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
