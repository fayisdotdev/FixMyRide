import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyBookingController extends GetxController {
  var isLoading = false.obs;

  String? userName;
  String? userPhone;

  Future<Map<String, dynamic>> prepareEmergencyRequestData({
    required String serviceName,
    required String vehicle,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    isLoading.value = true;

    try {
      String? email = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('userEmail', isEqualTo: email)
          .limit(1)
          .get();

      String phoneNumber = "unknown";
      String name = "unknown";

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        phoneNumber = data['userPhone'] ?? "unknown";
        name = data['userName'] ?? "unknown";
      }

      userPhone = userPhone;
      userName = userName;

      // Just return the prepared data, no Firestore writing here
      return {
        'formData': {
          'serviceName': serviceName,
          'vehicle': vehicle,
          'description': description,
          'latitude': latitude,
          'longitude': longitude,
        },
        'userData': {
          'userEmail': email,
          'userName': name,
          'userPhone': phoneNumber,
        },
      };
    } catch (e) {
      Get.snackbar("Error", "Failed to prepare request data: $e");
      return {};
    } finally {
      isLoading.value = false;
    }
  }
}
