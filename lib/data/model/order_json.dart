import 'package:mister_twister/domain/entities/order_model.dart';

class OrderJson {
  int? id;
  Customer? customer;
  Driver? driver;
  Address? address;
  String? status;
  List<Items>? items;
  String? createdAt;

  OrderJson({
    this.id,
    this.customer,
    this.driver,
    this.address,
    this.status,
    this.items,
    this.createdAt,
  });

  OrderJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    driver = json['driver'] != null
        ? new Driver.fromJson(json['driver'])
        : null;
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }

  OrderModel toDomain() {
    return OrderModel(
      orderId: id!,
      userId: customer!.id!,
      status: status!,
      userName: customer!.user!.name!,
      address: customer!.addresses!.isEmpty
          ? "N/A"
          : customer!.addresses!.first.label!,
      userLat: double.parse(address!.latitude.toString()),
      userLng: double.parse(address!.longitude.toString()),
      phone: customer!.user!.phoneNumber ?? "",
      createdAt: createdAt!,
      driverName: driver == null ? "" : driver!.user!.name!,
      driverPhone: driver == null ? "" : driver!.user!.phoneNumber ?? "N/A",
    );
  }
}

class Customer {
  int? id;
  User? user;
  List<Addresses>? addresses;

  Customer({this.id, this.user, this.addresses});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? userType;
  String? phoneNumber;
  bool? isStaff;
  bool? isSuperuser;

  User({
    this.id,
    this.email,
    this.name,
    this.userType,
    this.phoneNumber,
    this.isStaff,
    this.isSuperuser,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    userType = json['user_type'];
    phoneNumber = json['phone_number'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['user_type'] = this.userType;
    data['phone_number'] = this.phoneNumber;
    data['is_staff'] = this.isStaff;
    data['is_superuser'] = this.isSuperuser;
    return data;
  }
}

class Addresses {
  int? id;
  String? label;
  String? longitude;
  String? latitude;

  Addresses({this.id, this.label, this.longitude, this.latitude});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}

class Driver {
  int? id;
  User? user;
  bool? isOnline;

  Driver({this.id, this.user, this.isOnline});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_online'] = this.isOnline;
    return data;
  }
}

class Address {
  double? latitude;
  double? longitude;

  Address({this.latitude, this.longitude});

  Address.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Items {
  int? id;
  Product? product;
  String? unitPrice;
  int? quantity;

  Items({this.id, this.product, this.unitPrice, this.quantity});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? new Product.fromJson(json['product'])
        : null;
    unitPrice = json['unit_price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    return data;
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
