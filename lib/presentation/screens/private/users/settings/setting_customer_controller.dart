import 'package:flutter/foundation.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/data/model/customer_profile_json.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingCustomerController extends ChangeNotifier {

  final ApiService _apiService = ApiService();

  bool isLoading = false;

  CustomerProfile customerProfile = CustomerProfile();

    Future<void> getCustomerProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();
    final response = await _apiService.getDataJwt("/customers/me/", authToken: preferences.getString("authToken"));
    if (response.isNotEmpty) {
      customerProfile = CustomerProfile.fromJson(response);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

}