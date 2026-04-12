class PaymentJson {
  String? message;
  Order? order;

  PaymentJson({this.message, this.order});

  PaymentJson.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  Customer? customer;
  Driver? driver;
  Address? address;
  String? status;
  String? paymentStatus;
  String? squarePaymentId;
  List<Items>? items;
  String? createdAt;

  Order({
    this.id,
    this.customer,
    this.driver,
    this.address,
    this.status,
    this.paymentStatus,
    this.squarePaymentId,
    this.items,
    this.createdAt,
  });

  Order.fromJson(Map<String, dynamic> json) {
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
    paymentStatus = json['payment_status'];
    squarePaymentId = json['square_payment_id'];
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
    data['payment_status'] = this.paymentStatus;
    data['square_payment_id'] = this.squarePaymentId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Customer {
  int? id;
  User? user;
  // List<String>? addresses;
  String? image;

  Customer({this.id, this.user, this.image});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    // if (json['addresses'] != null) {

    //   json['addresses'].forEach((v) {
    //     addresses!.add(new .fromJson(v));
    //   });
    // }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    // if (this.addresses != null) {
    //   data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    // }
    data['image'] = this.image;
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

class Driver {
  int? id;
  User? user;
  bool? isOnline;
  Null? image;

  Driver({this.id, this.user, this.isOnline, this.image});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isOnline = json['is_online'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_online'] = this.isOnline;
    data['image'] = this.image;
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
