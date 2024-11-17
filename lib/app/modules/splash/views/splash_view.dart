import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo and centered text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/a.jpg', // Replace with the path to your logo image
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    height: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),

            // Footer section
            const Positioned(
              top: 10,
              right: 10,
              child: Center(
                child: Text(
                  'Version: 1.0.0-beta.1', // Replace with your desired footer text
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 14,
              right: 0,
              left: 0,
              child: Center(
                child: Text(
                  '© 2024 app.com.mm. All rights reserved.', // Updated copyright text, // Replace with your desired footer text
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
