import 'dart:io';

import 'package:mister_twister/domain/entities/catagory_model.dart';
import 'package:mister_twister/domain/entities/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> fetchProducts();
  Future<List<CatagoryModel>> fetchCategories();
  // Future<Map<String, dynamic>> fetchProductDetails(String productId);
  Future<bool> addProduct(
    String name,
    int stock,
    double unitPrice,
    int category,
    List<File> images,
  );
}
