import 'package:fixmyride/users/forms/confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaintenanceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController preferredDateController = TextEditingController();
  final TextEditingController preferredTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> submitForm(String serviceName) async {
    if (formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        final email = user?.email ?? "anonymous";

        // Cache values BEFORE using them
        final String vehicle = vehicleTypeController.text.trim();
        final String date = preferredDateController.text.trim();
        final String time = preferredTimeController.text.trim();
        final String description = descriptionController.text.trim();

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

        // // ✅ Add to Firestore
        // await FirebaseFirestore.instance.collection('maintenance_requests').add({
        //   "serviceName": serviceName,
        //   "vehicle": vehicle,
        //   "date": date,
        //   "time": time,
        //   "description": description,
        //   "userName": name,
        //   "userPhone": phoneNumber,
        //   "userEmail": email,
        //   "timestamp": FieldValue.serverTimestamp(),
        // });

        // ✅ Navigate to ConfirmationPage
        Get.to(
          () => ConfirmationPage(
            formType: "Maintenance",
            formData: {
              "serviceName": serviceName,
              "vehicle": vehicle,
              "date": date,
              "time": time,
              "description": description,
            },
            userData: {
              "userName": name,
              "userPhone": phoneNumber,
              "userEmail": email,
            },
          ),
        );

        // Optional: clear fields
        vehicleTypeController.clear();
        preferredDateController.clear();
        preferredTimeController.clear();
        descriptionController.clear();
      } catch (e) {
        Get.snackbar("Error", "Failed to submit: $e");
      }
    }
  }

  Future<void> selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      preferredDateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      // ignore: use_build_context_synchronously
      preferredTimeController.text = pickedTime.format(context);
    }
  }

  @override
  void onClose() {
    vehicleTypeController.dispose();
    preferredDateController.dispose();
    preferredTimeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}