import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmyride/admin/controllers/admin_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageAdminsPage extends StatelessWidget {
  const ManageAdminsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAdminController());

    return Scaffold(
      appBar: AppBar(title: const Text("Admins")),
      body: StreamBuilder(
        stream: controller.adminsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No admins found.'));
          }

          final admins = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: admins.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final admin = admins[index];
              final name = admin['adminName'] ?? 'No Name';
              final email = admin['adminEmail'] ?? 'No Email';
              final phone = admin['adminPhone'] ?? 'No Phone';
              final createdAt = admin['createdAt'] != null
                  ? (admin['createdAt'] as Timestamp)
                      .toDate()
                      .toLocal()
                      .toString()
                      .split('.')[0]
                  : 'Unknown';

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $email'),
                      Text('Phone: $phone'),
                      Text('Created At: $createdAt'),
                    ],
                  ),
                  leading: const Icon(Icons.admin_panel_settings, color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
