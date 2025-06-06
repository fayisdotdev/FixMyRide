import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewSellerProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  ViewSellerProfilePage({super.key, required this.data});

  final nameController = TextEditingController();
  final shopNameController = TextEditingController();
  final shopPlaceController = TextEditingController();
  final sellerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = data['sellerName'];
    shopNameController.text = data['shopName'];
    shopPlaceController.text = data['shopPlace'];
    sellerPhoneController.text = data['shopNumber'] ?? "";

    return Scaffold(
      appBar: AppBar(title: Text("Seller Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Seller Name"),
            ),
            TextFormField(
              controller: shopNameController,
              decoration: InputDecoration(labelText: "Shop Name"),
            ),
            TextFormField(
              controller: shopPlaceController,
              decoration: InputDecoration(labelText: "Shop Place"),
            ),
            TextFormField(
              controller: sellerPhoneController,
              decoration: InputDecoration(labelText: "Shop Phone"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final uid = data['uid'];
                await FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(uid)
                    .update({
                      'sellerName': nameController.text.trim(),
                      'shopName': shopNameController.text.trim(),
                      'shopPlace': shopPlaceController.text.trim(),
                      'sellerPhone': sellerPhoneController.text.trim(),
                    });
                Get.snackbar("Updated", "Profile updated successfully");
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
