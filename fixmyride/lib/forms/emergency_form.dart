import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/controllers/emergency_booking_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'confirmation_page.dart'; // <- Import your confirmation page

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

      // Save the emergency request
      await controller.submitEmergencyRequest(
        serviceName: widget.serviceName,
        vehicle: vehicle,
        description: description,
        latitude: latitude!,
        longitude: longitude!,
      );

      // Fetch user info from controller (assumes controller stores it)
      final userName =
          controller.userName; // You should assign this in the controller
      final userPhone = controller.userPhone;

      // Navigate to Confirmation Page
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder:
              (_) => ConfirmationPage(
                formType: "Emergency",
                formData: {
                  'Service': widget.serviceName,
                  'Vehicle': vehicle,
                  'Description': description,
                  'Location': 'Lat: $latitude, Lng: $longitude',
                },
                userData: {
                  'Name': userName ?? "N/A",
                  'Phone': userPhone ?? "N/A",
                },
              ),
        ),
      );

      // Clear form
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
            ],
          ),
        ),
      ),
    );
  }
}
