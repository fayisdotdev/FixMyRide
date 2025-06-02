import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageDrivers extends StatelessWidget {
  const ManageDrivers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drivers"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drivers').orderBy('driverName').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading drivers'));
          }

          final drivers = snapshot.data!.docs;

          if (drivers.isEmpty) {
            return const Center(child: Text('No drivers found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: drivers.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final driver = drivers[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: driver['profileImageUrl'] != null && driver['profileImageUrl'].toString().isNotEmpty
                      ? NetworkImage(driver['profileImageUrl'])
                      : null,
                  child: driver['profileImageUrl'] == null || driver['profileImageUrl'].toString().isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(driver['driverName'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${driver['driverPhone'] ?? 'N/A'}'),
                    Text('Availability: ${driver['availabilityStatus'] ?? 'Unknown'}'),
                    Text('Vehicle: ${driver['driverVehicle'] ?? 'Unknown'}'),
                    Text('Current Place: ${driver['currentPlace'] ?? 'Unknown'}'),
                    Text('Email: ${driver['driverEmail'] ?? 'Unknown'}'),
                    Text('Native: ${driver['nativePlace'] ?? 'Unknown'}'),
                    Text('Experience: ${driver['experience'] ?? 'Unknown'}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
