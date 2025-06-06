import 'package:fixmyride/users/drawer/development_team.dart';
import 'package:fixmyride/users/drawer/view_products.dart';
import 'package:fixmyride/users/drawer/view_drivers.dart';
import 'package:fixmyride/users/drawer/view_garages.dart';
import 'package:fixmyride/users/screens/booked_services.dart';
import 'package:fixmyride/users/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/users/controllers/home_page_controller.dart';
import 'package:fixmyride/users/controllers/login_register_controller.dart';
import 'package:fixmyride/styles/service_buttons.dart';

import 'package:fixmyride/users/forms/emergency_form.dart';
import 'package:fixmyride/users/forms/maintenance_form.dart';

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
              } else if (value == 'edit_profile') {
                Get.to(() => UserProfilePage());
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Text('Edit Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'booked_services',
                  child: Text('Booked Services'),
                ),
                PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
              ];
            },
          ),
        ],
      ),

      // ✅ Drawer Added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Obx(() {
                final userName =
                    authController.userName.value.isNotEmpty
                        ? authController.userName.value
                        : 'User';
                return Text(
                  'Hello, $userName!',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                );
              }),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () {
                Get.back(); // close drawer
                Get.to(() => UserProfilePage());
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Booked Services'),
              onTap: () {
                Get.back();
                Get.to(() => BookedServicesScreen());
              },
            ),

            Divider(),
            ListTile(
              leading: const Icon(Icons.view_agenda),
              title: const Text('Drivers'),
              onTap: () {
                Get.back();
                Get.to(() => ViewDriversPage());
              },
            ),

            Divider(),
            ListTile(
              leading: const Icon(Icons.garage),
              title: const Text('Garages'),
              onTap: () {
                Get.back();
                Get.to(() => ViewGaragesPage());
              },
            ),

            Divider(),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits_sharp),
              title: const Text('View Products'),
              onTap: () {
                Get.back();
                Get.to(() => ViewAllProductsPage());
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.developer_mode_outlined),
              title: const Text('Developers'),
              onTap: () {
                Get.back();
                Get.to(() => DevelopmentTeam());
              },
            ),
            Divider(),
          ],
        ),
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
                    final service = services[index];

                    return customButtonLayout(
                      label: service.name,
                      icon: service.icon,
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
