import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmyride/admin/admin_home.dart';
import 'package:fixmyride/screens/home_page.dart';
import 'package:fixmyride/screens/login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var isLoading = false.obs;
  RxString userName = ''.obs;

  // Text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // for registration
  final phoneController = TextEditingController(); // for registration

  // Password visibility toggles
  var isPasswordHidden = true.obs; // Login screen
  var isSignupPasswordHidden = true.obs; // Signup screen

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordHidden.value = !isSignupPasswordHidden.value;
  }

  /// Register user and add to Firestore
  Future<void> registerUser() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar("Missing Fields", "Please fill in all the fields");
      return;
    }

    isLoading.value = true;

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "userName": nameController.text.trim(),
          "userEmail": emailController.text.trim(),
          "userPhone": phoneController.text.trim(),
          "createdAt": FieldValue.serverTimestamp(),
        });

        Get.snackbar("Success", "Account created successfully");
        clearControllers();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  /// Login user
  Future<void> loginUser() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar("Missing Fields", "Please enter email and password");
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.snackbar("Success", "Login successful");
      clearControllers();

      await detectUserRoleAndRedirect();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  /// Detect user role and redirect to appropriate homepage
  Future<void> detectUserRoleAndRedirect() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      // Check 'admins' collection
      final adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists) {
        final data = adminDoc.data();
        userName.value = data?['adminName'] ?? '';
        Get.offAll(() => AdminHome(
              name: data?['adminName'] ?? '',
              email: data?['adminEmail'] ?? '',
              phone: data?['adminPhone'] ?? '',
            ));
        return;
      }

      // Check 'users' collection
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        userName.value = data?['userName'] ?? '';
        Get.offAll(() => HomePage());
        return;
      }

      // TODO: Add checks for 'drivers', 'garages', etc. if needed

      Get.snackbar('Error', 'User role not found in database.');
    } catch (e) {
      Get.snackbar('Error', 'Role detection failed: ${e.toString()}');
    }
  }

  /// Clear all controllers
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
  }

  /// Logout user
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      clearControllers();
      Get.offAll(() => const LoginScreen());
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: ${e.toString()}');
    }
  }

  /// (Optional) Fetch user name directly from 'users' collection
  Future<void> fetchUserProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final data = userDoc.data();
          userName.value = data?['userName'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user profile: ${e.toString()}');
    }
  }
}
