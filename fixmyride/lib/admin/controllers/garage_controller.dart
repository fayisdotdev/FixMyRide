import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GarageController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive List for garage documents
  RxList<QueryDocumentSnapshot> garages = <QueryDocumentSnapshot>[].obs;
  RxBool isLoading = false.obs;

  // Text Controllers
  final nameController = RxnString();
  final locationController = RxnString();
  final phoneController = RxnString();
  final emailController = RxnString();
  final servicesController = RxnString();
  final workingHoursController = RxnString();

  Future<void> fetchGarages() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('garages')
          .orderBy('timestamp', descending: true)
          .get();
      garages.value = snapshot.docs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch garages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addGarage() async {
    try {
      final addedByEmail = _auth.currentUser?.email ?? 'Unknown';

      await _firestore.collection('garages').add({
        'name': nameController.value?.trim(),
        'location': locationController.value?.trim(),
        'phone': phoneController.value?.trim(),
        'email': emailController.value?.trim(),
        'services': servicesController.value?.trim(),
        'workingHours': workingHoursController.value?.trim(),
        'addedBy': addedByEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Garage added successfully');
      clearFields();
      fetchGarages(); // refresh list after adding
    } catch (e) {
      Get.snackbar('Error', 'Failed to add garage: $e');
    }
  }

  void clearFields() {
    nameController.value = '';
    locationController.value = '';
    phoneController.value = '';
    emailController.value = '';
    servicesController.value = '';
    workingHoursController.value = '';
  }
}
