import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Fix My Ride',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 21, 74, 165),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'wherever you go, we will be there.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 21, 74, 165),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
