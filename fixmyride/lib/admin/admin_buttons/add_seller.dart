import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSellerController extends GetxController {
  final sellerNameController = TextEditingController();
  final sellerMailController = TextEditingController();
  final shopNameController = TextEditingController();
  final shopPlaceController = TextEditingController();
  final shopNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerSeller() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: sellerMailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;
      Timestamp createdAt = Timestamp.now();

      // 2. Store additional data in Firestore
      await _firestore.collection('sellers').doc(uid).set({
        'sellerName': sellerNameController.text.trim(),
        'sellerMail': sellerMailController.text.trim(),
        'shopName': shopNameController.text.trim(),
        'shopPlace': shopPlaceController.text.trim(),
        'shopNumber': shopNumberController.text.trim(),
        'uid': uid,
        'createdAt': createdAt,
      });

      Get.snackbar("Success", "Seller registered successfully");
      clearFields();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    sellerNameController.clear();
    sellerMailController.clear();
    shopNameController.clear();
    shopPlaceController.clear();
    shopNumberController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    sellerNameController.dispose();
    sellerMailController.dispose();
    shopNameController.dispose();
    shopPlaceController.dispose();
    shopNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class AddSellerPage extends StatelessWidget {
  final AddSellerController controller = Get.put(AddSellerController());

  AddSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Seller")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.sellerNameController,
                decoration: InputDecoration(labelText: 'Seller Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: controller.sellerMailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value!.isEmpty || !value.contains('@')
                            ? 'Enter valid email'
                            : null,
              ),
              TextFormField(
                controller: controller.shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: controller.shopPlaceController,
                decoration: InputDecoration(labelText: 'Shop Place'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: controller.shopNumberController,
                decoration: InputDecoration(labelText: 'Shop Contact Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) =>
                        value!.length < 6
                            ? 'Minimum 6 characters required'
                            : null,
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.registerSeller,
                  child:
                      controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Register Seller"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
