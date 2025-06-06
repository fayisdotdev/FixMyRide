// views/manage_seller_products_page.dart
import 'package:fixmyride/seller/controllers/seller_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSellerProductsPage extends StatelessWidget {
  final String sellerEmail;

  ManageSellerProductsPage({super.key, required this.sellerEmail}) {
    final controller = Get.put(SellerProductsController());
    controller.setSellerEmail(sellerEmail);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerProductsController>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Products")),
      body: Obx(() {
        if (controller.sellerProducts.isEmpty) {
          return const Center(child: Text("No products added yet."));
        }

        return ListView.builder(
          itemCount: controller.sellerProducts.length,
          itemBuilder: (context, index) {
            final product = controller.sellerProducts[index];

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: product['imageUrl'] != ""
                    ? Image.network(product['imageUrl'], width: 60, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(product['productName']),
                subtitle: Text("Price: ₹${product['productPrice']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteProduct(product['id']),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
