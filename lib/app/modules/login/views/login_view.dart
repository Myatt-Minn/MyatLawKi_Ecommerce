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
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'ဖုန်းနံပါတ်',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'E.g 09123456',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => controller.clearErrorMessages(),
              ),
              const SizedBox(height: 20),

              // Password input
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'စကားဝှက်',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      ),
                    ),
                    onChanged: (value) => controller.clearErrorMessages(),
                  )),
              const SizedBox(height: 20),

              // Sign In Button
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.loginUser();
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
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFF4E1E1E), // Dark brown background color
    );
  }
}
