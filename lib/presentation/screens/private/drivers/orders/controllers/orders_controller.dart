import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mister_twister/data/model/order_json.dart';
import 'package:mister_twister/data/model/payment_json.dart';
import 'package:mister_twister/domain/driver/order_repository.dart';
import 'package:mister_twister/domain/entities/order_model.dart';

class OrdersController extends ChangeNotifier {
  OrderRepository _orderRepository;

  OrdersController(this._orderRepository);

  List<OrderModel> orders = [];

OrderJson onProgressOrder  = OrderJson();

double getOnProgressOrderTotal() {
  if (onProgressOrder != null && onProgressOrder!.items != null && onProgressOrder!.items!.isNotEmpty) {
    return onProgressOrder!.items!.fold<double>(
      0.0,
      (sum, item) => sum + 
        ((item.quantity != null ? double.parse(item.quantity.toString()) : 0.0) *
         (item.unitPrice != null ? double.parse(item.unitPrice!) : 0.0)),
    );
  }
  return 0.0;
}

// In OrdersController
void setSelectedFilter(String filter) {
  selectedFilter = filter;
  notifyListeners();
}

  Future<void> getOrder() async {
    final response = await _orderRepository.fetchOrder();
    orders = response;
    print(orders.length);
    notifyListeners();
  }

  Future<void> getOnGoingOrder() async {
    final response = await _orderRepository.getOnProgressOrder();
    onProgressOrder = response;
    notifyListeners();
  }

  Future<String> acceptOrder(int orderId) async {
    final response = await _orderRepository.acceptOrder(orderId);
    return response;
  }

  Future<String> completeOrder(int orderId) async {
    final response = await _orderRepository.completeOrder(orderId);
    return response;
  }

  Future<String> markAsDelivered(int orderId) async {
    final response = await _orderRepository.markAsDelivered(orderId);
    return response;
  }

  OrderModel? getActiveOrder() {
    
    for (final order in orders) {
      print("status " + order.status);
      if (order.status == 'out_for_delivery' || order.status == 'arrived') {
        return order;
      }
    }
    return null;
  }

  Future<OrderModel?> getArrivedOrder() async {
  
    for (final order in orders) {
      print("status " + order.status);
      if (order.status == 'arrived') {
        return order;
      }
    }
    return null;
  }


  Future<String> payment(String sourceId, int orderId) async {
    final response = await _orderRepository.makePayment(sourceId, orderId);
    return response;
  }

  // double calculateOrderTotal(List<OrderModel> items) {
  //   double total = 0;
  //   for (final item in items) {
  //     final price = double.parse(item.);
  //     final qty = item['quantity'] as int;
  //     total += price * qty;
  //   }
  //   return total;
  // }

  int getPendingOrdersCount() {
    return orders
        .where(
          (order) =>
              order.status == 'pending' ||
              order.status == 'driver_request_sent',
        )
        .length;
  }

  int getCompletedOrdersCount() {
    return orders.where((order) => order.status == 'delivered').length;
  }

  int getActiveOrdersCount() {
    return orders
        .where(
          (order) =>
              order.status == 'out_for_delivery' || order.status == 'arrived',
        )
        .length;
  }

  bool isLoading = false;

  String selectedFilter = 'driver_request_sent';

  /// 🔥 CHANGE FILTER
  void changeFilter(String value) {
    selectedFilter = value;
    notifyListeners();
  }

  /// 🔥 FILTERED LIST
  List<OrderModel> get filteredOrders {
    return orders.where((o) => o.status == selectedFilter).toList();
  }
}
