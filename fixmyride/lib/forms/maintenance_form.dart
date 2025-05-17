import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'confirmation_page.dart';

class MaintenanceFormScreen extends StatefulWidget {
  final String serviceName;

  const MaintenanceFormScreen({super.key, required this.serviceName});

  @override
  State<MaintenanceFormScreen> createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController preferredDateController = TextEditingController();
  final TextEditingController preferredTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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

        // ✅ Add to Firestore
        await FirebaseFirestore.instance.collection('maintenance_requests').add({
          "service": widget.serviceName,
          "vehicle": vehicle,
          "date": date,
          "time": time,
          "description": description,
          "name": name,
          "phone": phoneNumber,
          "email": email,
          "timestamp": FieldValue.serverTimestamp(),
        });

        // ✅ Navigate to ConfirmationPage
        Get.to(
          () => ConfirmationPage(
            formType: "Maintenance",
            formData: {
              "service": widget.serviceName,
              "vehicle": vehicle,
              "date": date,
              "time": time,
              "description": description,
            },
            userData: {
              "name": name,
              "phone": phoneNumber,
              "email": email,
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

  @override
  void dispose() {
    vehicleTypeController.dispose();
    preferredDateController.dispose();
    preferredTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maintenance - ${widget.serviceName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: vehicleTypeController,
                decoration: InputDecoration(
                  labelText: "Vehicle",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.directions_car_outlined),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter vehicle Details' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: preferredDateController,
                readOnly: true,
                onTap: () async {
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
                },
                decoration: const InputDecoration(
                  labelText: "Preferred Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: preferredTimeController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    preferredTimeController.text = pickedTime.format(context);
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Preferred Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a time' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Additional Notes",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                  elevation: 4,
                ),
                child: const Text(
                  "Submit Request",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
