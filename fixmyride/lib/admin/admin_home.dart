import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmyride/admin/add_admin.dart';
import 'package:fixmyride/admin/add_driver.dart';
import 'package:fixmyride/admin/add_garage.dart';
import 'package:fixmyride/admin/add_spare_parts.dart';
import 'package:fixmyride/admin/admin_details.dart';
import 'package:fixmyride/admin/manage_drivers.dart';
import 'package:fixmyride/admin/manage_garage.dart';
import 'package:fixmyride/screens/login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHome extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const AdminHome({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(
                  () =>
                      AdminDetailsPage(name: name, email: email, phone: phone),
                );
              },
              child: const Text('Admin Details'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const AddAdminPage()),
              child: const Text('Add Admin'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const AddDriverPage()),
              child: const Text('Add Driver'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const AddGaragePage()),
              child: const Text('Add Garages'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const AddSparePartPage()),
              child: const Text('Add Spare Parts'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const ManageDrivers()),
              child: const Text('Manage Drivers'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const ManageGaragesPage()),
              child: const Text('Manage Garages'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.to(() => const ManageGaragesPage()),
              child: const Text('Manage Spare Parts'),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
