import 'package:mister_twister/constant/app_urls.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/data/model/order_json.dart';
import 'package:mister_twister/domain/driver/order_repository.dart';
import 'package:mister_twister/domain/entities/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepoImp implements OrderRepository {
  ApiService _apiService = ApiService();
  @override
  Future<List<OrderModel>> fetchOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.getList(
      AppUrls.getOrder,
      authToken: prefs.getString('authToken'),
    );
    print(response);
    if (response.isNotEmpty) {
      return response
          .map<OrderModel>((json) => OrderJson.fromJson(json).toDomain())
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<String> acceptOrder(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataWithoutBody(
      "/orders/$orderId/accept_delivery/",
      authToken: prefs.getString('authToken'),
    );
    print(response);
    print(orderId);
    return response['message'] ?? 'Order not accepted successfully';
  }

  @override
  Future<String> markAsDelivered(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataWithoutBody(
      "/orders/$orderId/mark_arrived/",
      authToken: prefs.getString('authToken'),
    );
    print(response);
    print(orderId);
    return response['message'] ?? 'Order not marked as delivered successfully';
  }

  @override
  Future<String> completeOrder(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataWithoutBody(
      "/orders/$orderId/complete_delivery/",
      authToken: prefs.getString('authToken'),
    );
    print(response);
    print(orderId);
    return response['message'] ?? 'Order not completed successfully';
  }

  @override
  Future<String> makePayment(String sourceId, int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.postDataRegular(
      "${AppUrls.sumbitPayment}$orderId/pay/",
      {"source_id": sourceId},
      authToken: prefs.getString("authToken"),
    );
    print(response);
    return response["message"];
  }

  @override
  Future<OrderJson> getOnProgressOrder() async{
     final prefs = await SharedPreferences.getInstance();
    final response = await _apiService.getData(
      "${AppUrls.getOrder}/active",
      authToken: prefs.getString('authToken'),
    );
    print(response);
    if (response.isNotEmpty) {
      return OrderJson.fromJson(response);
    } else {
     return OrderJson();
    }
    
}
}
