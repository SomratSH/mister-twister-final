class CustomerProfile {
  int? id;
  User? user;
  List<Addresses>? addresses;
  String? image;

  CustomerProfile({this.id, this.user, this.addresses, this.image});

  CustomerProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
    image = json['image'];
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
