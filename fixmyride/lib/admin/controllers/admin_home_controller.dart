import 'package:fixmyride/admin/admin_buttons/add_seller.dart';
import 'package:fixmyride/admin/admin_buttons/manage_admins.dart';
import 'package:fixmyride/everyone/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixmyride/admin/admin_buttons/add_admin.dart';
import 'package:fixmyride/admin/admin_buttons/add_driver.dart';
import 'package:fixmyride/admin/admin_buttons/add_garage.dart';
import 'package:fixmyride/admin/admin_buttons/add_spare_parts.dart';
import 'package:fixmyride/admin/admin_buttons/manage_drivers.dart';
import 'package:fixmyride/admin/admin_buttons/manage_garage.dart';
import 'package:fixmyride/admin/admin_buttons/manage_spare_parts.dart';

class AdminAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;

  AdminAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFFE0E0E0),
  });
}

class AdminHomeController extends GetxController {
  final String name;
  final String email;
  final String phone;

  AdminHomeController({
    required this.name,
    required this.email,
    required this.phone,
  });

  final RxList<AdminAction> adminActions = <AdminAction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeActions();
  }

  void _initializeActions() {
    adminActions.addAll([
      // AdminAction(
      //   label: 'Admin Details',
      //   icon: Icons.person,
      //   onTap: () => Get.to(() =>
      //       AdminDetailsPage(name: name, email: email, phone: phone)),
      // ),
      AdminAction(
        label: 'Add Admin',
        icon: Icons.admin_panel_settings,
        onTap: () => Get.to(() => const AddAdminPage()),
      ),
      AdminAction(
        label: 'Manage Admins',
        icon: Icons.directions_car_filled,
        onTap: () => Get.to(() => const ManageAdminsPage()),
      ),
      AdminAction(
        label: 'Add Driver',
        icon: Icons.person_add,
        onTap: () => Get.to(() =>  AddDriverPage()),
      ),
      AdminAction(
        label: 'Manage Drivers',
        icon: Icons.directions_car_filled,
        onTap: () => Get.to(() =>  ManageDriversPage()),
      ),
      AdminAction(
        label: 'Add Garage',
        icon: Icons.garage,
        onTap: () => Get.to(() => AddGaragePage()),
      ),
      AdminAction(
        label: 'Manage Garages',
        icon: Icons.business,
        onTap: () => Get.to(() => ManageGaragesPage()),
      ),
      AdminAction(
        label: 'Add Spare Parts',
        icon: Icons.build,
        onTap: () => Get.to(() => const AddSparePartPage()),
      ),
      AdminAction(
        label: 'Manage Spare Parts',
        icon: Icons.settings,
        onTap: () => Get.to(() => ManageSparePartsPage()),
      ),
      //seller
      AdminAction(
        label: 'Add Seller',
        icon: Icons.settings,
        onTap: () => Get.to(() => AddSellerPage()),
      ),
      AdminAction(
        label: 'Manage Seller',
        icon: Icons.settings,
        onTap: () => Get.to(() => ManageSparePartsPage()),
      ),
    ]);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
  }
}
