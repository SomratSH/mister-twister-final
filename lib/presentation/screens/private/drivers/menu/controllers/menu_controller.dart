// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class MenuItem {
//   final String id;
//   final String name;
//   final double price;
//   final double? discountPrice;
//   final int quantity;
//   final String description;
//   final List<String> imagePaths;

//   MenuItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     this.discountPrice,
//     required this.quantity,
//     required this.description,
//     required this.imagePaths,
//   });

//   // Copy with method for updates
//   MenuItem copyWith({
//     String? id,
//     String? name,
//     double? price,
//     double? discountPrice,
//     int? quantity,
//     String? description,
//     List<String>? imagePaths,
//   }) {
//     return MenuItem(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       price: price ?? this.price,
//       discountPrice: discountPrice ?? this.discountPrice,
//       quantity: quantity ?? this.quantity,
//       description: description ?? this.description,
//       imagePaths: imagePaths ?? this.imagePaths,
//     );
//   }
// }

// class DriverMenuProvider extends ChangeNotifier {


//   MenuItem? editingItem;
//   bool isEditing = false;



//   void _populateFields() {
//     if (editingItem != null) {
//       nameController.text = editingItem!.name;
//       priceController.text = editingItem!.price.toString();
//       discountPriceController.text =
//           editingItem!.discountPrice?.toString() ?? '';
//       quantityController.text = editingItem!.quantity.toString();
//       descriptionController.text = editingItem!.description;
//       selectedImages.value = List.from(editingItem!.imagePaths);
//     }
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     priceController.dispose();
//     discountPriceController.dispose();
//     quantityController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   MenuItem? menuItem;

//   getViewMenu(String menuId) {
//     if (menuId.isNotEmpty) {
//       // menuItem = getMenuItemById(menuId);
//       notifyListeners();
//     }
//   }
// }
