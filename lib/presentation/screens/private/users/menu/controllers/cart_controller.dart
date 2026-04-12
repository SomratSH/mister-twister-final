import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mister_twister/domain/entities/cart_model.dart';
import 'package:mister_twister/domain/entities/product_model.dart';
import 'package:mister_twister/domain/user/cart_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../common/models/menu_item.dart';

class CartController extends ChangeNotifier {
  CartRepository _cartRepository;

  CartController(this._cartRepository);
  List<ProductModel> cart = [];
  List<CartModel> cartItems = [];

  var latitude = 12.222;

  var deliveryAddress;

  var fullName;

  String? phoneNumber;

  String? email;

  String? deliveryInstructions;

  String? orderNotes;

  Future<void> getCartItemList() async {
    final response = await _cartRepository.fetchCartItems();
    cartItems = response;
    notifyListeners();
  }

  Future<void> addToCart(ProductModel item) async {
    final status = await _cartRepository.addToCart({
      "product_id": item.id,
      "quantity": 1,
    });
    if (status) {
      cart.add(item);
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, String itemId, int quantity) async {
    if (quantity > 0) {
      await _cartRepository.updateQtyuantity(itemId, quantity);
      cartItems[index].quantity = quantity;
      cartItems[index].totalPrice =
          double.parse(cartItems[index].unitPrice) * quantity;
      notifyListeners();
    }
  }

  String calculateSubtotal() {
    double total = 0;
    for (var item in cartItems) {
      final price = item.totalPrice;
      total += price;
    }
    return '\$${total.toStringAsFixed(2)}';
  }

  String calculateTax() {
    double subtotal = double.parse(calculateSubtotal().replaceAll('\$', ''));
    double tax = subtotal * 0.08;
    return '\$${tax.toStringAsFixed(2)}';
  }

  String calculateTotal() {
    double subtotal = double.parse(calculateSubtotal().replaceAll('\$', ''));
    double tax = subtotal * 0.08;
    double total = subtotal + tax;
    return '\$${total.toStringAsFixed(2)}';
  }

  void updateDeliveryLocation(param0, param1, param2) {}

  void updateContactInfo({
    required String name,
    required String phone,
    required String emailAddress,
  }) {}

  void updateDeliveryInstructions(String value) {}

  void updateOrderNotes(String value) {}

  bool validateCheckout() {
    return true;
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> placeOrder() async {
    final get = await getCurrentLocation();
    
    try {
  
      final response = await _cartRepository.placeOrder({
        // "address": {
        //   "latitude": get!.latitude.toString(),
        //   "longitude": get.longitude.toString(),
        // },
        "address": {"latitude": get!.latitude.toString(), "longitude": get.longitude.toString()},
      });
   
      if (response == true) {
        return response;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
