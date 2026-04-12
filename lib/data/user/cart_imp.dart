import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mister_twister/constant/app_urls.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/data/model/cart_json.dart';
import 'package:mister_twister/domain/entities/cart_model.dart';
import 'package:mister_twister/domain/user/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartImp implements CartRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<bool> addToCart(Map<String, dynamic> cartData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataRegular(
      AppUrls.addToCart,
      cartData,
      authToken: prefs.getString("authToken") ?? "",
    );
    if (response["id"] != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<CartModel>> fetchCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        return <CartModel>[];
      }

      final response = await _apiService.getList(
        AppUrls.cartItem,
        authToken: token,
      );
      return response
          .map<CartModel>((json) => CartJson.fromJson(json).toDomain())
          .toList();
    } catch (_) {
      return <CartModel>[];
    }
  }

  @override
  Future<bool> removeFromCart(String cartItemId) async {
    return false;
  }

  @override
  Future<bool> updateQtyuantity(String cartItemId, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      final response = await _apiService.patchData(
        '${AppUrls.udpateqty}$cartItemId/',
        {"quantity": quantity},
        authToken: token ?? '',
      );
      if (response["quantity"] != null) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> placeOrder(Map<String, dynamic> orderData) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataRegular(
      AppUrls.placeOrder,
      orderData,
      authToken: prefs.getString("authToken") ?? "",
    );
    print(response);
    if (response["address"] != null) {
      return true;
    } else {
      return false;
    }
  }
}
