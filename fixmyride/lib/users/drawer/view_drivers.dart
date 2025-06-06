import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewDriversPage extends StatefulWidget {
  const ViewDriversPage({super.key});

  @override
  State<ViewDriversPage> createState() => _ViewDriversPageState();
}

class _ViewDriversPageState extends State<ViewDriversPage> {
  Future<void> _refreshDrivers() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drivers")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('drivers')
                .orderBy('driverName')
                .snapshots(),
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _refreshDrivers,
            child:
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? const Center(child: Text('Error loading drivers'))
                    : (snapshot.data?.docs.isEmpty ?? true)
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text('No drivers found')),
                      ],
                    )
                    : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final driver =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                driver['profileImageUrl'] != null &&
                                        driver['profileImageUrl']
                                            .toString()
                                            .isNotEmpty
                                    ? NetworkImage(driver['profileImageUrl'])
                                    : null,
                            child:
                                driver['profileImageUrl'] == null ||
                                        driver['profileImageUrl']
                                            .toString()
                                            .isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                          ),
                          title: Text(driver['driverName'] ?? 'Unknown'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone: ${driver['driverPhone'] ?? 'N/A'}'),
                              Text(
                                'Availability: ${driver['availabilityStatus'] ?? 'Unknown'}',
                              ),
                              Text(
                                'Vehicle: ${driver['driverVehicle'] ?? 'Unknown'}',
                              ),
                              Text(
                                'Current Place: ${driver['currentPlace'] ?? 'Unknown'}',
                              ),
                              Text(
                                'Email: ${driver['driverEmail'] ?? 'Unknown'}',
                              ),
                              Text(
                                'Native: ${driver['nativePlace'] ?? 'Unknown'}',
                              ),
                              Text(
                                'Experience: ${driver['experience'] ?? 'Unknown'}',
                              ),
                            ],
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
