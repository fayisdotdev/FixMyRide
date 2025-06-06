
import 'package:fixmyride/users/controllers/maintenance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceFormScreen extends StatefulWidget {
  final String serviceName;

  const MaintenanceFormScreen({super.key, required this.serviceName});

  @override
  State<MaintenanceFormScreen> createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  final MaintenanceController controller = Get.put(MaintenanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maintenance - ${widget.serviceName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.vehicleTypeController,
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
                controller: controller.preferredDateController,
                readOnly: true,
                onTap: () => controller.selectDate(context),
                decoration: const InputDecoration(
                  labelText: "Preferred Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.preferredTimeController,
                readOnly: true,
                onTap: () => controller.selectTime(context),
                decoration: const InputDecoration(
                  labelText: "Preferred Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a time' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: "Additional Notes",
                  hintText: "Optional - Additional contact number, Vehicle Details",
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
                onPressed: () => controller.submitForm(widget.serviceName),
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