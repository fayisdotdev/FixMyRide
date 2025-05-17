import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookedServicesScreen extends StatelessWidget {
  BookedServicesScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> fetchEmergencyServices() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final snapshot = await _firestore
        .collection('emergency_requests')
        .where('userEmail', isEqualTo: user.email) // or use 'userEmail'
        .get();
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> fetchMaintenanceServices() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final snapshot = await _firestore
        .collection('maintenance_requests')
        .where('userEmail', isEqualTo: user.email) // or use 'userEmail'
        .get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Services'),
      ),
      body: FutureBuilder<List<List<QueryDocumentSnapshot>>>(
        future: Future.wait([
          fetchEmergencyServices(),
          fetchMaintenanceServices(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final emergencyDocs = snapshot.data?[0] ?? [];
          final maintenanceDocs = snapshot.data?[1] ?? [];

          if (emergencyDocs.isEmpty && maintenanceDocs.isEmpty) {
            return const Center(child: Text('No booked services found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (emergencyDocs.isNotEmpty) ...[
                const Text(
                  'Emergency Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...emergencyDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(data['vehicle'] ?? 'No vehicle info'),
                      subtitle: Text(data['description'] ?? ''),
                      trailing: Text(data['status'] ?? ''),
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
              if (maintenanceDocs.isNotEmpty) ...[
                const Text(
                  'Maintenance Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...maintenanceDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(data['vehicleType'] ?? 'No vehicle type'),
                      subtitle: Text(data['description'] ?? ''),
                      trailing: Text(data['preferredDate'] ?? ''),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }
}
