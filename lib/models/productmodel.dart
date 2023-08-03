class ProductModel {
  final String title;
  final String description;
  final double price;
  final String thumbnail;

  ProductModel({
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}
