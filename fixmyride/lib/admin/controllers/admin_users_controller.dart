// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAdminController extends GetxController {
  // 🔹 Form-related keys/controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  // 🔹 Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 State
  RxBool isSubmitting = false.obs;

  // 🔹 Add Admin Function
  Future<void> addAdmin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isSubmitting.value = true;

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();

        // Create Auth account
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final uid = userCredential.user!.uid;

        // Save to Firestore
        await _firestore.collection('admins').doc(uid).set({
          'adminEmail': email,
          'adminName': name,
          'adminPhone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'uid': uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin added successfully!')),
        );

        emailController.clear();
        passwordController.clear();
        nameController.clear();
        phoneController.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Auth Error: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  // 🔹 Stream Admins (for ManageAdminsPage)
  Stream<QuerySnapshot> get adminsStream => _firestore
      .collection('admins')
      .orderBy('createdAt', descending: true)
      .snapshots();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
