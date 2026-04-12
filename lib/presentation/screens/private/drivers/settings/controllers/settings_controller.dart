import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/data/model/driver_profile_json.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverSettingsProvider extends ChangeNotifier {

  DriverSettingsProvider(){
    init();
  }

  init()async{
    await getDriverProfile();

  }

  // Observable variables for shift settings
  bool isAutoShiftReminder = true;

  final ApiService _apiService = ApiService();

  // Observable variables for notifications
  bool isNewRequestAlerts = true;
  bool isSmartAlerts = true;

  // Observable variables for GPS settings
  bool isBackgroundLocation = true;
  bool isBroadcastLocation = true;

  // Shift information
  String shiftStatus = 'Active';
  String shiftStartTime = '9:30 AM';
  String gpsLastUsedTime = '3h 24m ago';

  void toggleAutoShiftReminder(bool value) {
    isAutoShiftReminder = value;
  }

  void toggleNewRequestAlerts(bool value) {
    isNewRequestAlerts = value;
  }

  void toggleSmartAlerts(bool value) {
    isSmartAlerts = value;
  }

  void toggleBackgroundLocation(bool value) {
    isBackgroundLocation = value;
  }

  void toggleBroadcastLocation(bool value) {
    isBroadcastLocation = value;
  }

  Future<void> endShiftAndLogout(BuildContext context) async {
    try {
      // Show confirmation dialog
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.orange,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'End Shift & Logout?',
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'You will no longer receive orders after logging out. Your shift will be marked as ended.',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                            
                        _performLogout(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Yes, End Shift',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF4A5FD9),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF4A5FD9),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to end shift: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _performLogout(BuildContext context)async {
    Get.snackbar(
      'Success',
      'Shift ended. See you next time!',
      snackPosition: SnackPosition.BOTTOM,
    );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      notifyListeners();
    // Navigate to login screen
    context.go(RoutePath.login);
  }

  DriverProfileModel driverProfileModel = DriverProfileModel();



  bool isLoading = false;

  Future<void> getDriverProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();
    final response = await _apiService.getDataJwt("/drivers/me/", authToken: preferences.getString("authToken"));
    if (response.isNotEmpty) {
      driverProfileModel = DriverProfileModel.fromJson(response);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
  

  Future<void> updateStatus(bool value, BuildContext context) async {
    
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await _apiService.patchData("/drivers/me/", {
     "is_online": value
    },
     authToken: preferences.getString("authToken")
    );

    if(response["is_online"] == value){
      driverProfileModel.isOnline = value;
      notifyListeners();
    }else{
      CustomSnackbar.show(context, message: "Something wrong, try again", backgroundColor: Colors.red);
    }
  }
}
