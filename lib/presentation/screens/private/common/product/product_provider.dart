import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/domain/common/product_repository.dart';
import 'package:mister_twister/domain/entities/catagory_model.dart';
import 'package:mister_twister/domain/entities/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;
  ProductProvider(this._productRepository);
  List<ProductModel> product = [];
  List<ProductModel> cart = [];
  List<CatagoryModel> categories = [];

  Future<void> getProduct() async {
    final response = await _productRepository.fetchProducts();
    product = response;
    notifyListeners();
  }

  Future<void> getCategories() async {
    final response = await _productRepository.fetchCategories();
    categories = response;
    notifyListeners();
  }

  String getProductName(int id) {
    try {
      final prod = product.firstWhere((element) => element.id == id);
      return prod.name;
    } catch (e) {
      return "Unknown Product";
    }
  }

  String getProductImage(int id) {
    try {
      final prod = product.firstWhere((element) => element.id == id);
      return prod.imageUrl.isEmpty ? "" : prod.imageUrl[0];
    } catch (e) {
      return "";
    }
  }

  String selectedCategory = "Cone";

  void selectCategory(String cat) {
    selectedCategory = cat;
    notifyListeners();
  }

  final ImagePicker _imagePicker = ImagePicker();
  List<File> selectedImages = [];

  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        selectedImages.add(File(image.path));
        notifyListeners();
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: "Failed to pick image",
        backgroundColor: Colors.red,
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void clearImages() {
    selectedImages.clear();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEditing = false;

  bool isLoading = false;

  Future<bool> createProduct() async {
    isLoading = true;
    notifyListeners();
    final response = await _productRepository.addProduct(
      nameController.text,
      int.parse(quantityController.text),
      double.parse(priceController.text),
      1,
      selectedImages,
    );
    if (response == true) {
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
