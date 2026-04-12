import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool showConfirmPassword = false.obs;

  void passwordListener() {
    final password = passwordController.text;
    if (password.length >= 6) {
      showConfirmPassword.value = true;
    } else {
      showConfirmPassword.value = false;
    }
  }
}
