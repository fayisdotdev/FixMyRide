import 'package:fixmyride/everyone/login_screen.dart';
import 'package:fixmyride/seller/add_products.dart';
import 'package:fixmyride/seller/seller_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerHomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxMap<String, dynamic> sellerData = <String, dynamic>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellerDetails();
  }

  void fetchSellerDetails() async {
    isLoading.value = true;
    try {
      final sellerMail = _auth.currentUser?.email;
      if (sellerMail == null) throw "User not logged in";

      final snapshot =
          await _firestore
              .collection('sellers')
              .where('sellerMail', isEqualTo: sellerMail)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        sellerData.value = snapshot.docs.first.data();
      } else {
        Get.snackbar("Error", "Seller data not found.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

class SellerHomePage extends StatelessWidget {
  final SellerHomeController controller = Get.put(SellerHomeController());

  SellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text("Seller Home"),
  actions: [
    IconButton(
      icon: Icon(Icons.logout),
      tooltip: "Logout",
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => LoginScreen()); // Replace with your actual login page
      },
    ),
  ],
),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final data = controller.sellerData;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, ${data['sellerName']}!",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => Get.to(() => ViewSellerProfilePage(data: data)),
                child: Text("View/Edit Profile"),
              ),
              ElevatedButton(
                onPressed: () => Get.to(() => AddProductPage(data: data)),
                child: Text("Add Product"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
