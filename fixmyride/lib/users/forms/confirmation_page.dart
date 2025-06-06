// confirmation_page.dart
import 'package:fixmyride/users/controllers/confirmation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationPage extends StatelessWidget {
  final String formType;
  final Map<String, dynamic> formData;
  final Map<String, dynamic> userData;

  ConfirmationPage({
    super.key,
    required this.formType,
    required this.formData,
    required this.userData,
  });

  final controller = Get.put(ConfirmationController());

  @override
  Widget build(BuildContext context) {
    final combinedData = {...formData, ...userData};

    return Scaffold(
      appBar: AppBar(title: Text('$formType Confirmation')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                "Please confirm your details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...combinedData.entries.map(
                (entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text('${entry.value}'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => controller.submitToFirebase(
                      formType: formType,
                      formData: formData,
                      userData: userData,
                    ),
                child: const Text("Confirm & Submit"),
              ),
            ],
          ),
        );
      }),
    );
  }
}