// views/manage_drivers_page.dart
import 'package:fixmyride/admin/controllers/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageDriversPage extends StatelessWidget {
  ManageDriversPage({super.key});

  final DriverController controller = Get.put(DriverController());

  Future<void> _onRefresh() async {
    // Force rebuild by calling update() in the controller
    // If needed, you could fetch fresh data manually here
    controller.update();
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Optional: simulate loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drivers")),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: StreamBuilder(
          stream: controller.getDriversStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading drivers"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No drivers found"));
            }

            return ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Required for RefreshIndicator
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final driver =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  driver['profileImageUrl'] != null &&
                                          driver['profileImageUrl']
                                              .toString()
                                              .isNotEmpty
                                      ? NetworkImage(driver['profileImageUrl'])
                                      : null,
                              child:
                                  driver['profileImageUrl'] == null ||
                                          driver['profileImageUrl']
                                              .toString()
                                              .isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                driver['driverName'] ?? 'Unknown Driver',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text("📞 Phone: ${driver['driverPhone'] ?? 'N/A'}"),
                        Text("📧 Email: ${driver['driverEmail'] ?? 'N/A'}"),
                        Text("🚗 Vehicle: ${driver['driverVehicle'] ?? 'N/A'}"),
                        Text(
                          "📍 Current Place: ${driver['currentPlace'] ?? 'N/A'}",
                        ),
                        Text("🏠 Native: ${driver['nativePlace'] ?? 'N/A'}"),
                        Text("📅 Experience: ${driver['experience'] ?? 'N/A'}"),
                        Text(
                          "✅ Availability: ${driver['availabilityStatus'] ?? 'N/A'}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
