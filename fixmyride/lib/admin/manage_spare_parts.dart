import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageSparePartsPage extends StatelessWidget {
  const ManageSparePartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spare Parts Inventory"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('spare_parts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading spare parts"));
          }

          final parts = snapshot.data?.docs ?? [];

          if (parts.isEmpty) {
            return const Center(child: Text("No spare parts available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final data = parts[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(data['partName'] ?? 'Unknown Part'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Model: ${data['vehicleModel'] ?? 'N/A'}"),
                      Text("Quantity: ${data['quantity'] ?? 'N/A'}"),
                      Text("Price: \$${data['price']?.toStringAsFixed(2) ?? '0.00'}"),
                      Text("Added By: ${data['addedByEmail'] ?? 'Unknown'}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
