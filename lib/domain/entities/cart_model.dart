class CartModel {
  int cardId;
  int productId;
  String productName;
  int quantity;
  String unitPrice;
  double totalPrice;
  CartModel({
    required this.cardId,
    required this.productName,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.unitPrice,
  });
}
