import 'package:fixmyride/admin/controllers/garage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddGaragePage extends StatelessWidget {
  AddGaragePage({super.key});

  final GarageController controller = Get.put(GarageController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Garage")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(label: "Garage Name", onChanged: (val) => controller.nameController.value = val),
              const SizedBox(height: 10),
              buildField(label: "Location", onChanged: (val) => controller.locationController.value = val),
              const SizedBox(height: 10),
              buildField(label: "Phone Number", keyboardType: TextInputType.phone, onChanged: (val) => controller.phoneController.value = val),
              const SizedBox(height: 10),
              buildField(label: "Email", keyboardType: TextInputType.emailAddress, onChanged: (val) => controller.emailController.value = val),
              const SizedBox(height: 10),
              buildField(label: "Services Offered", onChanged: (val) => controller.servicesController.value = val),
              const SizedBox(height: 10),
              buildField(label: "Working Hours", onChanged: (val) => controller.workingHoursController.value = val),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.addGarage();
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add Garage"),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String)? onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) => value == null || value.trim().isEmpty ? 'Enter $label' : null,
    );
  }
}
