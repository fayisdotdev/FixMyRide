import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSparePartPage extends StatefulWidget {
  const AddSparePartPage({super.key});

  @override
  State<AddSparePartPage> createState() => _AddSparePartPageState();
}

class _AddSparePartPageState extends State<AddSparePartPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController partNameController = TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSubmitting = false;

  Future<void> submitSparePart() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSubmitting = true);

      final userEmail = _auth.currentUser?.email ?? 'unknown';

      try {
        await _firestore.collection('spare_parts').add({
          'partName': partNameController.text.trim(),
          'vehicleModel': vehicleModelController.text.trim(),
          'quantity': int.parse(quantityController.text.trim()),
          'price': double.parse(priceController.text.trim()),
          'addedByEmail': userEmail,  // <-- user's email added here
          'timestamp': FieldValue.serverTimestamp(),
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spare part added successfully!')),
        );

        // Clear the form fields after successful submission
        partNameController.clear();
        vehicleModelController.clear();
        quantityController.clear();
        priceController.clear();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add spare part: $e')),
        );
      } finally {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    partNameController.dispose();
    vehicleModelController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Spare Part"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: partNameController,
                decoration: const InputDecoration(
                  labelText: 'Part Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter part name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: vehicleModelController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Model',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter vehicle model' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter quantity';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter price';
                  if (double.tryParse(value) == null) return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitSparePart,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Spare Part'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
