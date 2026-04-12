import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordCProvider extends ChangeNotifier{
  final emailController = TextEditingController();
  @override
  void onClose() {
    emailController.dispose();

  }
}