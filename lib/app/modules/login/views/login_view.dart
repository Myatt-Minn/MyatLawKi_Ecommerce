import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Logo at the top
              Image.asset(
                ConstsConfig.logo, // Replace with your logo path
                height: 150,
              ),

              // Title and subtitle
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              // Phone Number input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ဖုန်းနံပါတ်',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => TextField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        errorText: controller.emailError.value.isEmpty
                            ? null
                            : controller.emailError.value,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'E.g 09123456',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Password input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'စကားဝှက်နံပါတ်',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: '*************',
                        errorText: controller.passwordError.value.isEmpty
                            ? null
                            : controller.passwordError.value,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            controller.isPasswordHidden.value =
                                !controller.isPasswordHidden.value;
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sign In Button
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ဝင်ရောက်မည်',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    )),
              Text(
                controller.generalError.value,
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),

              // Forgot Password link
              GestureDetector(
                onTap: () {
                  Get.toNamed('/forgot-password');
                },
                child: const Text(
                  'အကောင့်ဝင်ရန်စကားဝှက်မေ့သွားပါသလား?',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/signup');
                },
                child: const Text(
                  'အကောင့်မရှိပါက ပြုလုပ်ရန်နှိပ်ပါ',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAllNamed('/navigation-screen');
                },
                child: const Text(
                  'ဧည့်သည်အကောင့်ဖြင့်ဝင်ရောက်ပါ။',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF4E1E1E), // Dark brown background color
    );
  }
}
