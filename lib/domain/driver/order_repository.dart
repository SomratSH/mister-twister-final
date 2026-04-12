import 'package:mister_twister/data/model/order_json.dart';
import 'package:mister_twister/domain/entities/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> fetchOrder();
  Future<OrderJson> getOnProgressOrder();
  Future<String> acceptOrder(int orderId);
  Future<String> markAsDelivered(int orderId);
  Future<String> completeOrder(int orderId);
  Future<String> makePayment(String sourceId, int orderId);
}
