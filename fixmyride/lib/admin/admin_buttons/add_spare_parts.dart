import 'package:fixmyride/admin/controllers/spare_parts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSparePartPage extends StatelessWidget {
  const AddSparePartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SparePartsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Add Spare Part")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.partNameController,
                decoration: const InputDecoration(
                  labelText: 'Part Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter part name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.vehicleModelController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Model',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter vehicle model' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.quantityController,
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
                controller: controller.priceController,
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
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.submitSparePart(
                              context: context,
                              onStart: () => controller.isSubmitting.value = true,
                              onComplete: () =>
                                  controller.isSubmitting.value = false,
                            ),
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Spare Part'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
