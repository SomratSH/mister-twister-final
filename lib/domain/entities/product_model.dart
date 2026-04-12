class ProductModel {
  int id;
  String name;
  String description;
  String price;
  List<String> imageUrl;
  String stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });
}
