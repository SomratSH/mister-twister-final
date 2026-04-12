import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mister_twister/constant/app_urls.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/data/model/category_json.dart';
import 'package:mister_twister/data/model/product_json.dart';
import 'package:mister_twister/domain/common/product_repository.dart';
import 'package:mister_twister/domain/entities/catagory_model.dart';
import 'package:mister_twister/domain/entities/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepoImp implements ProductRepository {
  final ApiService _apiService = ApiService();
  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _apiService.getList(AppUrls.productFetch);

      if (response.isNotEmpty) {
        return response
            .map<ProductModel>((json) => ProductJson.fromJson(json).toDomain())
            .toList();
      }

      return [];
    } catch (e) {
      // Optional: log error
      return [];
    }
  }

  @override
  Future<List<CatagoryModel>> fetchCategories() async {
    try {
      final response = await _apiService.getList(AppUrls.categories);

      if (response.isNotEmpty) {
        return response
            .map<CatagoryModel>(
              (json) => CategoryJson.fromJson(json).toDomain(),
            )
            .toList();
      }

      return [];
    } catch (e) {
      // Optional: log error
      return [];
    }
  }

  // @override
  // Future<ProductModel> fetchProductDetails(String productId) {
  //   // TODO: Implement fetching product details
  //   throw UnimplementedError();
  // }

  @override
  Future<bool> addProduct(
    String name,
    int stock,
    double unitPrice,
    int category,
    List<File> images,
  ) async {
    try {
      final uri = Uri.parse(AppUrls.baseUrl + AppUrls.addProduct);
      final request = http.MultipartRequest('POST', uri);

      // ---------- Headers ----------
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'JWT $token',
      });

      // ---------- Fields ----------
      request.fields['name'] = name;
      request.fields['stock'] = stock.toString();
      request.fields['unit_price'] = unitPrice.toString();
      request.fields['category'] = category.toString();

   
      for (final image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images["url"]', // change to 'images' if backend requires
            image.path,
            filename: image.path.split('/').last,
          ),
        );
      }

      // ---------- Send ----------
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response: $responseBody');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Add Product Error: $e');
      return false;
    }
  }
}
