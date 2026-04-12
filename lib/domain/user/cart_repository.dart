import 'package:mister_twister/domain/entities/cart_model.dart';

abstract class CartRepository {
  Future<bool> addToCart(Map<String, dynamic> cartData);
  Future<List<CartModel>> fetchCartItems();
  Future<bool> updateQtyuantity(String cartItemId, int quantity);
  Future<bool> removeFromCart(String cartItemId);
  Future<bool> placeOrder(Map<String, dynamic> orderData);
}
