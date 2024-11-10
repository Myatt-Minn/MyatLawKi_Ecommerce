import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF4E0E0E), // Background color matching image
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return controller.isLoading.value
                    ? const LinearProgressIndicator()
                    : Container();
              }),
              const SizedBox(height: 10),
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png', // Replace with your logo path
                      width: 140,
                      height: 140,
                    ),
                    const SizedBox(
                        width: 10), // Adjusted to give some horizontal spacing
                    Flexible(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        children: [
                          // Create Account Text
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                              height: 5), // Reduced for a tighter layout

                          // Subtitle
                          const Text(
                            'Fill your information below to create an account',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            maxLines: 2, // Limit to 2 lines if needed
                            overflow: TextOverflow
                                .visible, // Ensure wrapping instead of overflow
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Form Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Name TextField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'အမည်',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Myat Min',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Phone Number TextField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ဖုန်းနံပါတ်',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controller.phoneController,
                          decoration: InputDecoration(
                            filled: true,
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
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Password TextField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'စကားဝှက်နံပါတ်',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controller.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '*************',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility_off),
                              onPressed: () {
                                // Add toggle visibility function if needed
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password TextField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'စကားဝှက်အတည်ပြုရန်',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '*************',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility_off),
                              onPressed: () {
                                // Add toggle visibility function if needed
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Terms & Conditions Checkbox
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.agreeTerms.value,
                              onChanged: (value) {
                                controller.agreeTerms.value = value ?? false;
                              },
                              activeColor: const Color(0xFFE1B000),
                            ),
                            const Text(
                              'Agree with Terms & Conditions',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.signUp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFE1B000), // Yellow button color
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'အကောင့်ဖွင့်ရန်',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Already have an account? Sign In
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/login");
                      },
                      child: const Text(
                        "အကောင့်ရှိပြီး",
                        style: TextStyle(
                          color: Color(0xFFE1B000),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
