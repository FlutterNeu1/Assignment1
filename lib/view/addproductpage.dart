import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controller/productcontroller.dart';
import '../models/productmodel.dart';
import '../service/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductController controller = Get.find<ProductController>();
  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedImage;
  bool _productAdded = false;
  final List<ProductModel> _addedProducts = [];
  final ApiService _apiService = ApiService();
  List<dynamic> _products = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _products = products;
      });

      final localStorage = GetStorage();
      localStorage.write('products', _products);
    } catch (e) {
      setState(() {
        _products = [];
      });
    }
  }

  Future<void> _uploadImageAndAddProduct() async {
    if (_pickedImage != null) {
      try {
        final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = firebaseStorageRef.putFile(_pickedImage!);
        await uploadTask;

        final imageUrl = await firebaseStorageRef.getDownloadURL();

        final product = ProductModel(
          title: controller.title.value,
          description: controller.description.value,
          price: controller.price.value,
          thumbnail: imageUrl,
        );

        final body = json.encode(product.toJson());

        const url = 'https://dummyjson.com/products/add';
        final headers = {'Content-Type': 'application/json'};
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          setState(() {
            _productAdded = true;
            _addedProducts.add(product);
          });
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontFamily: "Oswald-Regular"),
        ),
        backgroundColor: const Color.fromARGB(255, 125, 0, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => controller.title.value = value,
              decoration: InputDecoration(
                enabled: true,
                label: const Text(
                  "Title",
                  style: TextStyle(fontFamily: "Oswald-Regular"),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) => controller.description.value = value,
              decoration: InputDecoration(
                enabled: true,
                label: const Text(
                  "Description",
                  style: TextStyle(fontFamily: "Oswald-Regular"),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) =>
                  controller.price.value = double.tryParse(value) ?? 0.0,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabled: true,
                label: const Text(
                  "Price",
                  style: TextStyle(fontFamily: "Oswald-Regular"),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 125, 0, 241),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 50)), // Increase width
              ),
              child: const Text('Pick Image'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _uploadImageAndAddProduct,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 125, 0, 241),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 50)), // Increase width
              ),
              child: const Text('Add Product'),
            ),
            if (_productAdded)
              const Text(
                'Product added successfully!',
                style: TextStyle(color: Colors.green),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _addedProducts.length,
                itemBuilder: (context, index) {
                  final product = _addedProducts[index];
                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                      leading: Image.network(
                        product.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
