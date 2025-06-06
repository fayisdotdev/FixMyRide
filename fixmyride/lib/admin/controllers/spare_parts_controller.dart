// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SparePartsController extends GetxController {
  // 🔹 Shared resources
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Map<String, dynamic>> spareParts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _firestore
        .collection('spare_parts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          spareParts.value =
              snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList();
        });
  }

  // -----------------------------------------------------
  // 🔸 FORM SECTION (For Add Page)
  // -----------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final partNameController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  RxBool isSubmitting = false.obs;

  Future<void> submitSparePart({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onComplete,
  }) async {
    if (formKey.currentState!.validate()) {
      onStart();

      final user = _auth.currentUser;
      final userEmail = user?.email ?? 'unknown';
      String addedByName = 'Unknown';

      try {
        // Check admin
        final adminSnapshot =
            await _firestore
                .collection('admins')
                .where('adminEmail', isEqualTo: userEmail)
                .limit(1)
                .get();

        if (adminSnapshot.docs.isNotEmpty) {
          addedByName = adminSnapshot.docs.first['adminName'] ?? 'Unknown';
        } else {
          // Check user
          final userSnapshot =
              await _firestore
                  .collection('users')
                  .where('userEmail', isEqualTo: userEmail)
                  .limit(1)
                  .get();

          if (userSnapshot.docs.isNotEmpty) {
            addedByName = userSnapshot.docs.first['userName'] ?? 'Unknown';
          }
        }

        // Add to Firestore
        await _firestore.collection('spare_parts').add({
          'partName': partNameController.text.trim(),
          'vehicleModel': vehicleModelController.text.trim(),
          'quantity': int.parse(quantityController.text.trim()),
          'price': double.parse(priceController.text.trim()),
          'addedByEmail': userEmail,
          'addedByName': addedByName,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spare part added successfully!')),
        );

        // Clear fields
        partNameController.clear();
        vehicleModelController.clear();
        quantityController.clear();
        priceController.clear();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add spare part: $e')));
      } finally {
        onComplete();
      }
    }
  }

  // -----------------------------------------------------
  // 🔸 MANAGEMENT SECTION (For Manage Page)
  // -----------------------------------------------------
  RxBool isRefreshing = false.obs;

  Stream<QuerySnapshot> get sparePartsStream =>
      _firestore
          .collection('spare_parts')
          .orderBy('timestamp', descending: true)
          .snapshots();

  @override
  Future<void> refresh() async {
    isRefreshing.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isRefreshing.value = false;
    update(); // notify listeners
  }

  Future<void> deleteSparePart(String docId) async {
    await _firestore.collection('spare_parts').doc(docId).delete();
  }

  // -----------------------------------------------------
  // Cleanup
  // -----------------------------------------------------
  @override
  void onClose() {
    partNameController.dispose();
    vehicleModelController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
