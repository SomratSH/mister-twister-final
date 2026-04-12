import 'package:flutter/material.dart';
import 'package:mister_twister/common/models/user_type.dart';
import 'package:mister_twister/domain/auth/auth_repository.dart';

class SignupProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  SignupProvider(this._authRepository) {
    passwordController.addListener(_passwordListener);
  }

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // UI state
  bool obscurePassword = true;
  bool showConfirmPassword = false;
  bool isLoading = false;
  String? errorMessage;

  // Password listener
  void _passwordListener() {
    final password = passwordController.text;
    final shouldShow = password.length >= 6;
    if (showConfirmPassword != shouldShow) {
      showConfirmPassword = shouldShow;
      notifyListeners();
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // Sign up function
  Future<bool> signUp() async {
    final body = {
      'name': firstNameController.text.trim() + lastNameController.text.trim(),
      "phone_number": phoneController.text.trim(),
      'email': emailController.text.trim(),
      "user_type": selectedRole == UserRole.customer ? 'customer' : 'driver',
      'password': passwordController.text.trim(),
      're_password': confirmPasswordController.text.trim(),
    };

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authRepository.signUp(body);

      isLoading = false;
      notifyListeners();

      if (response.containsKey('error')) {
        errorMessage = response['error'];
        return false;
      }

      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    passwordController.removeListener(_passwordListener);

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  UserRole selectedRole = UserRole.customer;

  void selectRole(UserRole role) {
    selectedRole = role;
    notifyListeners();
  }
}
