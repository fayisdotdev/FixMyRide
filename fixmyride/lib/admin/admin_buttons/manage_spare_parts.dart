import 'package:fixmyride/admin/controllers/spare_parts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSparePartsPage extends StatelessWidget {
  const ManageSparePartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SparePartsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Spare Parts Inventory")),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refresh();
          },
          child: controller.spareParts.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("No spare parts available")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.spareParts.length,
                  itemBuilder: (context, index) {
                    final data = controller.spareParts[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['partName'] ?? 'Unknown Part',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("🚗 Model: ${data['vehicleModel'] ?? 'N/A'}"),
                            Text("🔢 Quantity: ${data['quantity'] ?? 'N/A'}"),
                            Text("💰 Price: \$${(data['price'] ?? 0).toStringAsFixed(2)}"),
                            Text("🧑‍💼 Added By: ${data['addedByName'] ?? 'Unknown'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
