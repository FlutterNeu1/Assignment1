import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://dummyjson.com/products';

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> products = responseData['products'];
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
