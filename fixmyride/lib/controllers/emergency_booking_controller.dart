import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyBookingController extends GetxController {
  var isLoading = false.obs;

  // ✅ Store fetched user info for access after submission
  String? userName;
  String? userPhone;

  Future<void> submitEmergencyRequest({
    required String serviceName,
    required String vehicle,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    isLoading.value = true;

    try {
      String? email = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

      // 🔍 Fetch user name and phone from "users" collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      String phoneNumber = "unknown";
      String name = "unknown";

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        phoneNumber = data['phone'] ?? "unknown";
        name = data['name'] ?? "unknown";
      }

      // ✅ Assign to controller variables
      userPhone = phoneNumber;
      userName = name;

      // Save the request to Firestore
      await FirebaseFirestore.instance.collection('emergency_requests').add({
        'serviceName': serviceName,
        'vehicle': vehicle,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'userEmail': email,
        'userName': name,
        'userPhone': phoneNumber,
        'status': 'pending',
      });

      // Get.snackbar("Success", "Emergency request submitted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit request: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
