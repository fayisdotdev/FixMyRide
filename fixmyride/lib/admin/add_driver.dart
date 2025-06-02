// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nativePlaceController = TextEditingController();
  final TextEditingController currentPlaceController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController profileImageUrlController = TextEditingController();

  String availabilityStatus = 'Available';
  String status = 'Approved';
  bool isSubmitting = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitDriver() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSubmitting = true);

      try {
        final currentUser = _auth.currentUser;

        await _firestore.collection('drivers').add({
          'driverName': nameController.text.trim(),
          'driverPhone': phoneController.text.trim(),
          'driverEmail': emailController.text.trim(),
          'nativePlace': nativePlaceController.text.trim(),
          'currentPlace': currentPlaceController.text.trim(),
          'driverVehicle': vehicleController.text.trim(),
          'experience': experienceController.text.trim(),
          'profileImageUrl': profileImageUrlController.text.trim(),
          'availabilityStatus': availabilityStatus,
          'status': status,
          'addedBy': currentUser?.email ?? 'Unknown',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver added successfully!')),
        );

        // Clear the form
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        nativePlaceController.clear();
        currentPlaceController.clear();
        vehicleController.clear();
        experienceController.clear();
        profileImageUrlController.clear();
        setState(() => availabilityStatus = 'Available');
        setState(() => status = 'Approved');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add driver: $e')),
        );
      } finally {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nativePlaceController.dispose();
    currentPlaceController.dispose();
    vehicleController.dispose();
    experienceController.dispose();
    profileImageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Driver")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Name'),
              _buildTextField(phoneController, 'Phone', keyboardType: TextInputType.phone),
              _buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress),
              _buildTextField(nativePlaceController, 'Native Place'),
              _buildTextField(currentPlaceController, 'Current Place'),
              _buildTextField(vehicleController, 'Vehicle'),
              _buildTextField(experienceController, 'Experience (Optional)', required: false),
              _buildTextField(profileImageUrlController, 'Profile Image URL', required: false),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: availabilityStatus,
                decoration: const InputDecoration(
                  labelText: 'Availability Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Available', child: Text('Available')),
                  DropdownMenuItem(value: 'Unavailable', child: Text('Unavailable')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => availabilityStatus = value);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Not Approved', child: Text('Not Approved')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => status = value);
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitDriver,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Driver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = true, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) =>
            required && (value == null || value.trim().isEmpty) ? 'Enter $label' : null,
      ),
    );
  }
}