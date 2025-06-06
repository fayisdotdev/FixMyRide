// controllers/driver_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nativePlaceController = TextEditingController();
  final currentPlaceController = TextEditingController();
  final vehicleController = TextEditingController();
  final experienceController = TextEditingController();
  final profileImageUrlController = TextEditingController();

  final availabilityStatus = 'Available'.obs;
  final status = 'Approved'.obs;

  final isSubmitting = false.obs;

  Future<void> addDriver() async {
    if ((GetUtils.isNullOrBlank(nameController.text) == true) ||
        (GetUtils.isNullOrBlank(phoneController.text) == true) ||
        (GetUtils.isNullOrBlank(emailController.text) == true) ||
        (GetUtils.isNullOrBlank(nativePlaceController.text) == true) ||
        (GetUtils.isNullOrBlank(currentPlaceController.text) == true) ||
        (GetUtils.isNullOrBlank(vehicleController.text) == true)) {
      Get.snackbar("Error", "Please fill all required fields.");
      return;
    }

    isSubmitting.value = true;
    try {
      final currentUser = _auth.currentUser;
      await _firestore.collection('drivers').add({
        'driverName': nameController.text.trim(),
        'driverPhone': phoneController.text.trim(),
        'driverEmail': emailController.text.trim(),
        'nativePlace': nativePlaceController.text.trim(),
        'currentPlace': currentPlaceController.text.trim(),
        'driverVehicle': vehicleController.text.trim(),
        'experience': experienceController.text.trim(),
        'profileImageUrl': profileImageUrlController.text.trim(),
        'availabilityStatus': availabilityStatus.value,
        'status': status.value,
        'addedBy': currentUser?.email ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      });

      clearFields();
      Get.snackbar("Success", "Driver added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add driver: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    nativePlaceController.clear();
    currentPlaceController.clear();
    vehicleController.clear();
    experienceController.clear();
    profileImageUrlController.clear();
    availabilityStatus.value = 'Available';
    status.value = 'Approved';
  }

  Stream<QuerySnapshot> getDriversStream() {
    return _firestore.collection('drivers').orderBy('driverName').snapshots();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nativePlaceController.dispose();
    currentPlaceController.dispose();
    vehicleController.dispose();
    experienceController.dispose();
    profileImageUrlController.dispose();
    super.onClose();
  }
}
