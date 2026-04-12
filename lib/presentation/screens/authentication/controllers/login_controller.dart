import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginProvider(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool obscurePassword = true.obs;

  void checkUser(BuildContext context, String status) {
    print(status);
    if (status == "customer") {
      context.go(RoutePath.home);
    } else if (status == "driver") {
      context.go(RoutePath.homeDriver);
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool isLoading = false;

  Future<String> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await _authRepository.login({
        "email": email,
        "password": password,
      });

      if (response["access"] != null) {
        final data = await _authRepository.authUserDetails(response["access"]);
        print(data);
        if (data["user_type"] != null) {
          await prefs.setString('authToken', response["access"]);
          await prefs.setString('refreshToken', response["refresh"].toString());
          await prefs.setString("userType", data["user_type"]);

          CustomSnackbar.show(context, message: "Login Successful");
        }
        isLoading = false;
        notifyListeners();
        return data["user_type"];
      } else {
        isLoading = false;
        notifyListeners();
        CustomSnackbar.show(
          context,
          message: response["message"] ?? "Login Failed",
        );
      }
    } catch (e) {
       isLoading = false;
      notifyListeners();
      debugPrint("Login error: $e");
      CustomSnackbar.show(context, message: "Something went wrong");
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return "Null";
  }
}
