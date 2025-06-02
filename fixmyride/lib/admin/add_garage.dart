import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGaragePage extends StatefulWidget {
  const AddGaragePage({super.key});

  @override
  State<AddGaragePage> createState() => _AddGaragePageState();
}

class _AddGaragePageState extends State<AddGaragePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController workingHoursController = TextEditingController();
  final TextEditingController addedByController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isSubmitting = false;

  Future<void> submitGarage() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSubmitting = true);

      try {
        await _firestore.collection('garages').add({
          'name': nameController.text.trim(),
          'location': locationController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'services': servicesController.text.trim(),
          'workingHours': workingHoursController.text.trim(),
          'addedBy': addedByController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Garage added successfully!')),
        );

        // Clear form
        nameController.clear();
        locationController.clear();
        phoneController.clear();
        emailController.clear();
        servicesController.clear();
        workingHoursController.clear();
        addedByController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add garage: $e')),
        );
      } finally {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    servicesController.dispose();
    workingHoursController.dispose();
    addedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Garage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(controller: nameController, label: 'Garage Name'),
              const SizedBox(height: 10),
              buildTextField(controller: locationController, label: 'Location'),
              const SizedBox(height: 10),
              buildTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 10),
              buildTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              buildTextField(
                  controller: servicesController,
                  label: 'Services Offered'),
              const SizedBox(height: 10),
              buildTextField(
                  controller: workingHoursController,
                  label: 'Working Hours (e.g. 9am - 6pm)'),
              const SizedBox(height: 10),
              buildTextField(
                  controller: addedByController, label: 'Added By (email)'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitGarage,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Garage'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }
}
