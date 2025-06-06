import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ServiceItem {
  final String name;
  final IconData icon;

  ServiceItem({required this.name, required this.icon});
}

class HomeController extends GetxController {
  // 0 = Maintenance, 1 = Emergency
  RxInt selectedIndex = 0.obs;

  // Getter for selected service category
  String get selectedCategory =>
      selectedIndex.value == 0 ? 'maintenance' : 'emergency';

  // List of maintenance services
  final List<ServiceItem> maintenanceServices = [
    ServiceItem(name: "Full Service", icon: Icons.build_circle_outlined),
    ServiceItem(name: "Brake Issues", icon: Icons.car_repair),
    ServiceItem(name: "Engine Overheating", icon: Icons.thermostat_outlined),
    ServiceItem(
      name: "Check Engine Light On",
      icon: Icons.warning_amber_rounded,
    ),
  ];
  // List of emergency services

  final List<ServiceItem> emergencyServices = [
    ServiceItem(name: "Dead Battery", icon: Icons.battery_alert),
    ServiceItem(name: "Flat or Worn-out Tires", icon: Icons.tire_repair),
    ServiceItem(name: "Fuel / Charge Finished", icon: Icons.local_gas_station),
    ServiceItem(name: "Suddenly Stopped", icon: Icons.car_crash),
  ];

  // Getter for currently selected services
  List<ServiceItem> get currentServices =>
      selectedIndex.value == 0 ? maintenanceServices : emergencyServices;

  // To change selected tab (called from BottomNavigationBar)
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
