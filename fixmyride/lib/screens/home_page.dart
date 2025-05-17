import 'package:fixmyride/screens/booked_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/controllers/home_page_controller.dart';
import 'package:fixmyride/controllers/login_register_controller.dart';
import 'package:fixmyride/styles/service_buttons.dart'; 

import 'package:fixmyride/forms/emergency_form.dart';
import 'package:fixmyride/forms/maintenance_form.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController homeController = Get.put(HomeController());
  final LoginRegisterController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fix My Ride"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authController.logoutUser();
              } else if (value == 'booked_services') {
                Get.to(() => BookedServicesScreen());
              }
            },

            itemBuilder: (BuildContext context) {
              return [
                // const PopupMenuItem<String>(
                //   value: 'edit_profile',
                //   child: Text('Edit Profile'),
                // ),
                const PopupMenuItem<String>(
                  value: 'booked_services',
                  child: Text('Booked Services'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Obx(() {
            final userName =
                authController.userName.value.isNotEmpty
                    ? authController.userName.value
                    : 'User';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Hi, $userName!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final services = homeController.currentServices;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index]; // now a ServiceItem

                    return customButtonLayout(
                      label: service.name,
                      icon: service.icon, // Pass icon here
                      onTap: () {
                        if (homeController.selectedIndex.value == 0) {
                          Get.to(
                            () => MaintenanceFormScreen(
                              serviceName: service.name,
                            ),
                          );
                        } else {
                          Get.to(
                            () =>
                                EmergencyFormScreen(serviceName: service.name),
                          );
                        }
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: homeController.selectedIndex.value,
          onTap: homeController.updateSelectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Maintenance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Emergency',
            ),
          ],
        );
      }),
    );
  }
}
