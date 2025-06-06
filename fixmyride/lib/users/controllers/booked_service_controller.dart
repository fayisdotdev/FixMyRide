import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BookedServicesController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var emergencyServices = <QueryDocumentSnapshot>[].obs;
  var maintenanceServices = <QueryDocumentSnapshot>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      final emergencySnapshot = await _firestore
          .collection('emergency_requests')
          .where('userEmail', isEqualTo: user.email)
          .get();

      final maintenanceSnapshot = await _firestore
          .collection('maintenance_requests')
          .where('userEmail', isEqualTo: user.email)
          .get();

      emergencyServices.assignAll(emergencySnapshot.docs);
      maintenanceServices.assignAll(maintenanceSnapshot.docs);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteService(String docId, String type) async {
    final collection = type == 'emergency'
        ? 'emergency_requests'
        : 'maintenance_requests';
    await _firestore.collection(collection).doc(docId).delete();
    fetchServices();
  }

  Future<void> refreshServices() async {
  isLoading.value = true;
  await fetchServices(); // Fetches the booked services
  isLoading.value = false;
}

}
