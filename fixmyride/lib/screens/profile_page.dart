// pages/user_profile_page.dart
import 'package:fixmyride/controllers/profile_controller.dart';
import 'package:fixmyride/screens/booked_services.dart';
import 'package:fixmyride/styles/service_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});

  final controller = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUserProfile();

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileItem("Name", controller.userName.value),
              buildProfileItem("Email", controller.userEmail.value),
              buildProfileItem("Phone", controller.userPhone.value),

              TextButton(
                onPressed: () => Get.to(() => BookedServicesScreen()),
                child: Text("view my bookings"),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget _buildProfileItem(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       children: [
  //         Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
  //         Expanded(child: Text(value)),
  //       ],
  //     ),
  //   );
  // }
}