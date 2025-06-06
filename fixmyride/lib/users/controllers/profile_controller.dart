import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;

  var isLoading = false.obs;

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      userEmail.value = user.email ?? "unknown";

      final snapshot =
          await _firestore
              .collection('users')
              .where('userEmail', isEqualTo: user.email)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        userName.value = data['userName'] ?? 'N/A';
        userPhone.value = data['userPhone'] ?? 'N/A';
      } else {
        Get.snackbar("Not Found", "User profile not found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
