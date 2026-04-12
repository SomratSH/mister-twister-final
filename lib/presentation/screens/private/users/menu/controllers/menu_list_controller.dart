// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../../common/models/menu_item.dart';

// class MenuListProvider extends ChangeNotifier {
// 	final RxList<String> categories = <String>["All", "Cones", "Sundae", "Popsicle", "Specials"].obs;
// 	final RxString selectedCategory = "All".obs;

// 	final RxList<MenuItem> menuItems = <MenuItem>[
// 		MenuItem(
// 			id: '1',
// 			title: 'Classic Vanilla Cone',
// 			description: 'Creamy vanilla soft serve in a crispy cone',
// 			image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300&h=300&fit=crop',
// 			price: '\$3.99',
// 			category: 'Cones',
// 		),
// 		MenuItem(
// 			id: '2',
// 			title: 'Classic Vanilla Cone',
// 			description: 'Fresh strawberry ice cream with fruit chunks',
// 			image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=300&fit=crop',
// 			price: '\$5.99',
// 			category: 'Cones',
// 		),
// 		MenuItem(
// 			id: '3',
// 			title: 'Chocolate Swirl',
// 			description: 'Rich chocolate and vanilla twisted soft serve',
// 			image: 'https://images.unsplash.com/photo-1519864600265-abb23847ef2c?w=300&h=300&fit=crop',
// 			price: '\$3.99',
// 			category: 'Cones',
// 		),
// 		MenuItem(
// 			id: '4',
// 			title: 'Sundae Supreme',
// 			description: 'Vanilla ice cream with hot fudge, cream & cherry',
// 			image: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?w=300&h=300&fit=crop',
// 			price: '\$5.99',
// 			category: 'Sundae',
// 		),
// 		MenuItem(
// 			id: '5',
// 			title: 'Rainbow Popsicle',
// 			description: 'Fruity rainbow ice pop on a stick',
// 			image: 'https://images.unsplash.com/photo-1464306076886-debca5e8a6b0?w=300&h=300&fit=crop',
// 			price: '\$2.99',
// 			category: 'Popsicle',
// 		),
// 		MenuItem(
// 			id: '6',
// 			title: 'Chocolate Milkshake',
// 			description: 'Thick and creamy chocolate milkshake',
// 			image: 'https://images.unsplash.com/photo-1519864600265-abb23847ef2c?w=300&h=300&fit=crop',
// 			price: '\$4.99',
// 			category: 'Specials',
// 		),
// 	].obs;

// 	RxList<MenuItem> cart = <MenuItem>[].obs;

// 	List<MenuItem> get filteredMenu {
// 		if (selectedCategory.value == "All") {
// 			return menuItems;
// 		}
// 		return menuItems.where((item) => item.category == selectedCategory.value).toList();
// 	}



// 	void addToCart(MenuItem item) {
// 		if (!cart.contains(item)) {
// 			cart.add(item);
// 		}
// 	}

// }