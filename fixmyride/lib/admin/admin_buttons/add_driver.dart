// views/add_driver_page.dart
import 'package:fixmyride/admin/controllers/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDriverPage extends StatelessWidget {
  AddDriverPage({super.key});

  final DriverController controller = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Driver")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(controller.nameController, 'Name'),
            _buildTextField(controller.phoneController, 'Phone'),
            _buildTextField(controller.emailController, 'Email'),
            _buildTextField(controller.nativePlaceController, 'Native Place'),
            _buildTextField(controller.currentPlaceController, 'Current Place'),
            _buildTextField(controller.vehicleController, 'Vehicle'),
            _buildTextField(controller.experienceController, 'Experience (optional)', required: false),
            _buildTextField(controller.profileImageUrlController, 'Profile Image URL (optional)', required: false),
            const SizedBox(height: 12),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.availabilityStatus.value,
              decoration: const InputDecoration(labelText: 'Availability', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Available', child: Text('Available')),
                DropdownMenuItem(value: 'Unavailable', child: Text('Unavailable')),
              ],
              onChanged: (val) => controller.availabilityStatus.value = val!,
            )),
            const SizedBox(height: 12),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.status.value,
              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                DropdownMenuItem(value: 'Not Approved', child: Text('Not Approved')),
              ],
              onChanged: (val) => controller.status.value = val!,
            )),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
              onPressed: controller.isSubmitting.value ? null : controller.addDriver,
              child: controller.isSubmitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Driver"),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) => required && (value == null || value.trim().isEmpty)
            ? 'Enter $label'
            : null,
      ),
    );
  }
}
