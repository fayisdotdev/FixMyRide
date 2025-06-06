// controllers/public_products_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PublicProductsController extends GetxController {
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  void fetchAllProducts() {
    FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      allProducts.value =
          snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    });
  }
}
