import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/controllers/emergency_booking_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fixmyride/forms/confirmation_page.dart';

class EmergencyFormScreen extends StatefulWidget {
  final String serviceName;

  const EmergencyFormScreen({super.key, required this.serviceName});

  @override
  State<EmergencyFormScreen> createState() => _EmergencyFormScreenState();
}

class _EmergencyFormScreenState extends State<EmergencyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final EmergencyBookingController controller = Get.put(
    EmergencyBookingController(),
  );

  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  double? latitude;
  double? longitude;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (latitude == null || longitude == null) {
        Get.snackbar("Location Required", "Please allow location access.");
        return;
      }

      final vehicle = vehicleController.text.trim();
      final description = descriptionController.text.trim();

      // Prepare data without submitting to Firestore yet
      final data = await controller.prepareEmergencyRequestData(
        serviceName: widget.serviceName,
        vehicle: vehicle,
        description: description,
        latitude: latitude!,
        longitude: longitude!,
      );

      if (data.isEmpty) {
        // error already handled in controller
        return;
      }

      final formData = data['formData'] as Map<String, dynamic>;
      final userData = data['userData'] as Map<String, dynamic>;

      // Navigate to Confirmation Page with data
      Get.to(
        () => ConfirmationPage(
          formType: "Emergency",
          formData: formData,
          userData: userData,
        ),
      );

      // Clear form fields after navigation
      vehicleController.clear();
      descriptionController.clear();
    }
  }

  Future<void> _getLocation() async {
    final pos = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    vehicleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emergency - ${widget.serviceName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: vehicleController,
                decoration: const InputDecoration(
                  labelText: "Vehicle",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter vehicle type' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText:
                      "Optional - Vehicle number, Additional contact number, Nearby Landmark.",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text("Submit Request"),
              ),
              SizedBox(height: 20),
              Text(
                "Kindly check your device settings to allow location if not allowed.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
