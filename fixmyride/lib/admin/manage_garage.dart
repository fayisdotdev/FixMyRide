import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageGaragesPage extends StatefulWidget {
  const ManageGaragesPage({super.key});

  @override
  State<ManageGaragesPage> createState() => _ManageGaragesPageState();
}

class _ManageGaragesPageState extends State<ManageGaragesPage> {
  Future<void> _refreshGarages() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Garage List")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('garages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _refreshGarages,
            child:
                snapshot.hasError
                    ? const Center(child: Text("Error loading garages"))
                    : snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : (snapshot.data?.docs.isEmpty ?? true)
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text("No garages found.")),
                      ],
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final garage =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  garage['name'] ?? 'Unnamed Garage',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "📍 Location: ${garage['location'] ?? 'N/A'}",
                                ),
                                Text("📞 Phone: ${garage['phone'] ?? 'N/A'}"),
                                Text("📧 Email: ${garage['email'] ?? 'N/A'}"),
                                Text(
                                  "🛠️ Services: ${garage['services'] ?? 'N/A'}",
                                ),
                                Text(
                                  "⏰ Working Hours: ${garage['workingHours'] ?? 'N/A'}",
                                ),
                                Text(
                                  "🧑‍💼 Added By: ${garage['addedBy'] ?? 'N/A'}",
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
