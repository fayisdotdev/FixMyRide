import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmationController extends GetxController {
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitToFirebase({
    required String formType,
    required Map<String, dynamic> formData,
    required Map<String, dynamic> userData,
  }) async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final email = userData['userEmail'] ?? user.email ?? 'anonymous';

      final String userName =
          userData['userName'] ?? userData['name'] ?? 'unknown';
      final String userPhone =
          userData['userPhone'] ?? userData['phone'] ?? 'unknown';

      final Map<String, dynamic> dataToInsert = {
        'serviceName': formData['serviceName'] ?? '',
        'vehicle': formData['vehicle'] ?? '',
        'description': formData['description'] ?? '',
        'timestamp': DateTime.now().toIso8601String(),
        'userEmail': email,
        'userName': userName,
        'userPhone': userPhone,
        'status': 'pending',
      };

      if (formType.toLowerCase() == 'emergency') {
        dataToInsert['latitude'] = formData['latitude'];
        dataToInsert['longitude'] = formData['longitude'];
        dataToInsert['serviceName'] = formData['serviceName'];
      } else if (formType.toLowerCase() == 'maintenance') {
        dataToInsert['date'] = formData['date'] ?? '';
        dataToInsert['time'] = formData['time'] ?? '';
      }

      final String collection =
          formType.toLowerCase() == 'emergency'
              ? 'emergency_requests'
              : 'maintenance_requests';

      await _firestore.collection(collection).add(dataToInsert);

      Get.snackbar("Success", "Request submitted successfully");
      Get.until((route) => route.isFirst);
    } catch (e) {
      Get.snackbar("Error", "Failed to submit request: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
