import 'package:fixmyride/admin/controllers/garage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageGaragesPage extends StatelessWidget {
  ManageGaragesPage({super.key});

  final GarageController controller = Get.put(GarageController());

  @override
  Widget build(BuildContext context) {
    controller.fetchGarages(); // Load garages initially

    return Scaffold(
      appBar: AppBar(title: const Text("Garage List")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.garages.isEmpty) {
          return const Center(child: Text("No garages found."));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchGarages,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.garages.length,
            itemBuilder: (context, index) {
              final garage = controller.garages[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        garage['name'] ?? 'Unnamed Garage',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text("📍 Location: ${garage['location'] ?? 'N/A'}"),
                      Text("📞 Phone: ${garage['phone'] ?? 'N/A'}"),
                      Text("📧 Email: ${garage['email'] ?? 'N/A'}"),
                      Text("🛠️ Services: ${garage['services'] ?? 'N/A'}"),
                      Text("⏰ Working Hours: ${garage['workingHours'] ?? 'N/A'}"),
                      Text("🧑‍💼 Added By: ${garage['addedBy'] ?? 'N/A'}"),
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
