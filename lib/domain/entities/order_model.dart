class OrderModel {
  final int orderId;
  final int userId;
  final String status;
  final String userName;
  final String address;
  final double userLat;
  final double userLng;
  final String phone;
  final String createdAt;
  final String? driverName;
  final String? driverPhone;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.userName,
    required this.address,
    required this.userLat,
    required this.userLng,
    required this.phone,
    required this.createdAt,
    required this.driverName,
    required this.driverPhone,
  });
}
