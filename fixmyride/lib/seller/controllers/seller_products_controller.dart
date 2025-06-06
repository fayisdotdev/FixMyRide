// controllers/seller_products_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SellerProductsController extends GetxController {
  final RxList<Map<String, dynamic>> sellerProducts = <Map<String, dynamic>>[].obs;

  late String sellerEmail;

  void setSellerEmail(String email) {
    sellerEmail = email;
    fetchSellerProducts();
  }

  void fetchSellerProducts() {
    FirebaseFirestore.instance
        .collection('products')
        .where('sellerMail', isEqualTo: sellerEmail)
        .snapshots()
        .listen((snapshot) {
      sellerProducts.value =
          snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    });
  }

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    Get.snackbar("Deleted", "Product has been removed");
  }
}
