import 'package:fixmyride/users/controllers/booked_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookedServicesScreen extends StatelessWidget {
  BookedServicesScreen({super.key});
  final controller = Get.put(BookedServicesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booked Services')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.emergencyServices.isEmpty &&
            controller.maintenanceServices.isEmpty) {
          return const Center(child: Text('No booked services found.'));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshServices,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (controller.emergencyServices.isNotEmpty) ...[
                const Text(
                  'Emergency Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...controller.emergencyServices.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(doc.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) =>
                        controller.deleteService(doc.id, 'emergency'),
                    child: Card(
                      child: ListTile(
                        title: Text(data['vehicle'] ?? 'No vehicle info'),
                        subtitle: Text(
                          '${data['serviceName'] ?? ''}\n${data['description'] ?? ''}',
                        ),
                        trailing: Text(
                          'Latitude: ${data['latitude'] ?? ''},\nLogitude: ${data['longitude'] ?? ''}',
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
              if (controller.maintenanceServices.isNotEmpty) ...[
                const Text(
                  'Maintenance Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...controller.maintenanceServices.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(doc.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) =>
                        controller.deleteService(doc.id, 'maintenance'),
                    child: Card(
                      child: ListTile(
                        title: Text(data['vehicle'] ?? 'No vehicle info'),
                        subtitle: Text(
                          '${data['serviceName'] ?? ''}\n${data['description'] ?? ''}',
                        ),
                        trailing: Text(
                          'Date: ${data['date'] ?? ''}\nTime: ${data['time'] ?? ''}',
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      }),
    );
  }
}
