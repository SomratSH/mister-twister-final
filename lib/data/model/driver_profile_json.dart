class DriverProfileModel {
  int? id;
  User? user;
  bool? isOnline;
  String? image;
  String? shiftStart;
  String? shiftEnd;
  bool? isInShift;
  Summary? summary;

  DriverProfileModel(
      {this.id,
      this.user,
      this.isOnline,
      this.image,
      this.shiftStart,
      this.shiftEnd,
      this.isInShift,
      this.summary});

  DriverProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isOnline = json['is_online'];
    image = json['image'];
    shiftStart = json['shift_start'];
    shiftEnd = json['shift_end'];
    isInShift = json['is_in_shift'];
    summary =
        json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_online'] = this.isOnline;
    data['image'] = this.image;
    data['shift_start'] = this.shiftStart;
    data['shift_end'] = this.shiftEnd;
    data['is_in_shift'] = this.isInShift;
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
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

  User(
      {this.id,
      this.email,
      this.name,
      this.userType,
      this.phoneNumber,
      this.isStaff,
      this.isSuperuser});

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

class Summary {
  int? ordersToday;
  double? totalRevenueToday;
  int? totalCustomers;
  double? onlineTime;

  Summary(
      {this.ordersToday,
      this.totalRevenueToday,
      this.totalCustomers,
      this.onlineTime});

  Summary.fromJson(Map<String, dynamic> json) {
    ordersToday = json['orders_today'];
    totalRevenueToday = json['total_revenue_today'];
    totalCustomers = json['total_customers'];
    onlineTime = json['online_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders_today'] = this.ordersToday;
    data['total_revenue_today'] = this.totalRevenueToday;
    data['total_customers'] = this.totalCustomers;
    data['online_time'] = this.onlineTime;
    return data;
  }
}
