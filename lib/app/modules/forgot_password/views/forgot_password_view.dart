import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4B1E16), // Dark brown background color
      appBar: AppBar(
        backgroundColor: Color(0xFF4B1E16),
        title: Text(
          'ကုတ်ဝှက်ပြောင်းခြင်း',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              const SizedBox(height: 20),
              _buildPasswordField(
                  'လက်ရှိကုတ်ဝှက်ထည့်ပါ', controller.isObscured1.value, () {
                controller.togglePasswordVisibility();
              }),
              const SizedBox(height: 20),
              _buildPasswordField(
                  'ကုတ်ဝှက်အသစ်ထည့်ပါ', controller.isObscured2.value, () {
                controller.togglePasswordVisibility();
              }),
              const SizedBox(height: 20),
              _buildPasswordField(
                  'ကုတ်ဝှက်အတည်ပြုပါ', controller.isObscured3.value, () {
                controller.togglePasswordVisibility();
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC107), // Yellow color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Handle submit action
                  },
                  child: Text(
                    'အတည်ပြုပါ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, bool isObscured, VoidCallback toggleObscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isObscured,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleObscure,
            ),
          ),
        ),
      ],
    );
  }
}
