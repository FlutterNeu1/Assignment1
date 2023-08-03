import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_application/controller/authcontroller.dart';
import 'package:pdf_application/view/productdetailscreen.dart';

import '../service/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'addproductpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadLocalProducts();
    _fetchProducts();
  }

  Future<void> _loadLocalProducts() async {
    final localStorage = GetStorage();
    final localProducts = localStorage.read('products');
    if (localProducts != null) {
      setState(() {
        _products = localProducts;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 125, 0, 241),
            title: const Center(
              child: Text(
                'Product List',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w800,
                  fontFamily: "Oswald-Regular",
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  AuthController().logOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            expandedHeight: 60.0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        ProductDescriptionPage(product: product),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Image.network(
                          product['thumbnail'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          product['title'],
                          style: const TextStyle(fontFamily: "Oswald-Regular"),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['brand']),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product['price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
