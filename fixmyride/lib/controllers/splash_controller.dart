import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmyride/admin/admin_home.dart';
import 'package:fixmyride/controllers/login_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/screens/home_page.dart';
import 'package:fixmyride/screens/login_screen.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
    animationController.forward();

    Timer(const Duration(seconds: 3), _navigateUser);
  }

  Future<void> _navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final firestore = FirebaseFirestore.instance;

      try {
        final adminDoc = await firestore.collection('admins').doc(uid).get();
        if (adminDoc.exists) {
          // if It's an admin
          final data = adminDoc.data();
          Get.offAll(
            () => AdminHome(
              name: data?['adminName'] ?? '',
              email: data?['adminEmail'] ?? '',
              phone: data?['adminPhone'] ?? '',
            ),
          );

          return;
        }

        final userDoc = await firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          // if It's a regular user
          final loginController = Get.put(LoginRegisterController());
          loginController.userName.value = userDoc.data()?['userName'] ?? '';
          Get.offAll(() => HomePage());
          return;
        }

        // If user not found in either collection
        Get.snackbar('Error', 'User not found in database');
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => const LoginScreen());
      } catch (e) {
        Get.snackbar('Error', 'Failed to load user data: ${e.toString()}');
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => const LoginScreen());
      }
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
