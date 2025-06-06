import 'package:fixmyride/admin/admin_profile.dart';
import 'package:fixmyride/admin/controllers/admin_home_controller.dart';
import 'package:fixmyride/users/controllers/login_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixmyride/styles/service_buttons.dart';

class AdminHome extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const AdminHome({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final LoginRegisterController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminHomeController(
        name: widget.name,
        email: widget.email,
        phone: widget.phone,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authController.logoutUser();
              } else if (value == 'view_profile') {
                Get.to(
                  () => AdminDetailsPage(
                    name: widget.name,
                    email: widget.email,
                    phone: widget.phone,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
                PopupMenuItem<String>(
                  value: 'view_profile',
                  child: Text('View Profile'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final actions = controller.adminActions;
          return GridView.builder(
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];
              return customButtonLayout(
                label: action.label,
                icon: action.icon,
                onTap: action.onTap,
              );
            },
          );
        }),
      ),
    );
  }
}
