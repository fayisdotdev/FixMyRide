import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageSparePartsPage extends StatefulWidget {
  const ManageSparePartsPage({super.key});

  @override
  State<ManageSparePartsPage> createState() => _ManageSparePartsPageState();
}

class _ManageSparePartsPageState extends State<ManageSparePartsPage> {
  Future<void> _refreshSpareParts() async {
    // Triggers rebuild to simulate refresh. Firestore stream is always live.
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spare Parts Inventory")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('spare_parts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _refreshSpareParts,
            child:
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? const Center(child: Text("Error loading spare parts"))
                    : (snapshot.data?.docs.isEmpty ?? true)
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text("No spare parts available")),
                      ],
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

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
                                Text(
                                  "Price: \$${(data['price'] ?? 0).toStringAsFixed(2)}",
                                ),
                                Text(
                                  "Added By: ${data['addedByEmail'] ?? 'Unknown'}",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          );
        },
      ),
    );
  }
}
