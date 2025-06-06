// controllers/add_product_controller.dart
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  // Form Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final vehicleController = TextEditingController();
  final mfdController = TextEditingController();
  final quantityController = TextEditingController();
  final warrantyController = TextEditingController();

  // Image
  Uint8List? pickedImage;
  String? imageName;

  Map<String, dynamic> sellerData = {};

  void setSellerData(Map<String, dynamic> data) {
    sellerData = data;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      pickedImage = result.files.single.bytes!;
      imageName = result.files.single.name;
      update();
    }
  }

  Future<String?> uploadImageToStorage(
    String productName,
    String shopName,
  ) async {
    if (pickedImage == null || imageName == null) return null;

    try {
      String cleanedProductName = productName.replaceAll(' ', '_');
      String cleanedSellerName = shopName.replaceAll(' ', '_');
      String fileName = "${cleanedProductName}_$cleanedSellerName.jpg";

      final ref = FirebaseStorage.instance
          .ref()
          .child("products")
          .child(productName)
          .child(shopName)
          .child(fileName);

      // Set content type metadata explicitly
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

      UploadTask uploadTask = ref.putData(pickedImage!, metadata);
      TaskSnapshot snapshot = await uploadTask;

      // Return a fresh download URL with valid access token
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Image upload error: $e");
      return null;
    }
  }

  Future<void> submitProduct() async {
    String productName = nameController.text.trim();
    String sellerName = sellerData['sellerName'];

    if (productName.isEmpty) {
      Get.snackbar("Error", "Product name is required");
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final imageUrl = await uploadImageToStorage(productName, sellerName);

      await FirebaseFirestore.instance.collection('products').add({
        'productName': productName,
        'productPrice': priceController.text.trim(),
        'productVehicle': vehicleController.text.trim(),
        'mfd': mfdController.text.trim(),
        'quantity': quantityController.text.trim(),
        'warranty': warrantyController.text.trim(),
        'sellerMail': sellerData['sellerMail'],
        'sellerName': sellerName,
        'shopName': sellerData['shopName'],
        'shopNumber': sellerData['shopNumber'] ?? "",
        'imageUrl': imageUrl ?? "",
        'createdAt': Timestamp.now(),
      });

      clearFields();
      Get.back();
      Get.snackbar("Success", "Product added successfully");
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString());
    }
  }

  void clearFields() {
    nameController.clear();
    priceController.clear();
    vehicleController.clear();
    mfdController.clear();
    quantityController.clear();
    warrantyController.clear();
    pickedImage = null;
    imageName = null;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    vehicleController.dispose();
    mfdController.dispose();
    quantityController.dispose();
    warrantyController.dispose();
    super.onClose();
  }
}
