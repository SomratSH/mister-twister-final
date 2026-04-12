import 'package:mister_twister/domain/entities/cart_model.dart';

class CartJson {
  int? id;
  Product? product;
  int? quantity;
  double? totalPrice;

  CartJson({this.id, this.product, this.quantity, this.totalPrice});

  CartJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? new Product.fromJson(json['product'])
        : null;
    quantity = json['quantity'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['total_price'] = this.totalPrice;
    return data;
  }

  CartModel toDomain() {
    return CartModel(
      unitPrice: product?.unitPrice ?? '',
      productName: product?.name ?? '',
      cardId: id ?? 0,
      productId: product?.id ?? 0,
      quantity: quantity ?? 0,
      totalPrice: totalPrice ?? 0.0,
    );
  }
}

class Product {
  int? id;
  String? name;
  String? unitPrice;

  Product({this.id, this.name, this.unitPrice});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitPrice = json['unit_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['unit_price'] = this.unitPrice;
    return data;
  }
}
