// views/view_all_products_page.dart
import 'package:fixmyride/users/controllers/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllProductsPage extends StatelessWidget {
  ViewAllProductsPage({super.key}) {
    Get.put(PublicProductsController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PublicProductsController>();

    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: Obx(() {
        if (controller.allProducts.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        return ListView.builder(
          itemCount: controller.allProducts.length,
          itemBuilder: (context, index) {
            final product = controller.allProducts[index];

            // Debug print the imageUrl
            debugPrint("Product #$index imageUrl: ${product['imageUrl']}");

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: SizedBox(
                  width: 60,
                  height: 60,
                  child:
                      product['imageUrl'] != ""
                          ? Image.network(
                            product['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                "Image load error for product #$index: $error",
                              );
                              return const Icon(Icons.broken_image);
                            },
                          )
                          : const Icon(Icons.image_not_supported),
                ),
                title: Text(product['productName']),
                subtitle: Text(
                  "₹${product['productPrice']} | ${product['shopName']}",
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      "Coming Soon",
                      "Buy feature will be added soon",
                    );
                  },
                  child: const Text("Buy"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
