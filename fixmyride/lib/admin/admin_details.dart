import 'package:flutter/material.dart';

class AdminDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const AdminDetailsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Email: $email', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Phone: $phone', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
