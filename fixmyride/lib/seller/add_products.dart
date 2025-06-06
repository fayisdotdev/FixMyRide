// views/add_product_page.dart
import 'package:fixmyride/seller/controllers/add_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  final Map<String, dynamic> data;

  AddProductPage({super.key, required this.data}) {
    final controller = Get.put(AddProductController());
    controller.setSellerData(data);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: GetBuilder<AddProductController>(
        builder:
            (_) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                    ),
                  ),
                  TextFormField(
                    controller: controller.priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: controller.vehicleController,
                    decoration: const InputDecoration(labelText: "Vehicle"),
                  ),
                  TextFormField(
                    controller: controller.mfdController,
                    decoration: const InputDecoration(
                      labelText: "Manufacture Date",
                    ),
                  ),
                  TextFormField(
                    controller: controller.quantityController,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: controller.warrantyController,
                    decoration: const InputDecoration(
                      labelText: "Warranty/Guarantee",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Pick Image"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.imageName ?? "No image selected",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.submitProduct,
                    child: const Text("Add Product"),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
