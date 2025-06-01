import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmyride/controllers/login_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/screens/home_page.dart';
import 'package:fixmyride/screens/login_screen.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();

    Timer(const Duration(seconds: 3), _navigateUser);
  }

void _navigateUser() {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final loginController = Get.put(LoginRegisterController()); // Register controller
    loginController.fetchUserProfile(); // ✅ Fetch user name from Firestore
    Get.offAll(() => HomePage()); // Navigate after loading
  } else {
    Get.offAll(() => const LoginScreen());
  }
}



  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
