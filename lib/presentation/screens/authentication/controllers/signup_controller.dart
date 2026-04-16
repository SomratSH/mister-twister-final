import 'package:flutter/material.dart';
import 'package:mister_twister/common/models/user_type.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
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
Future<bool> signUp(BuildContext context) async {
  final body = {
    'name': "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
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

    // 1. Check if the response is an error (Contains field keys like 'email', 'phone_number')
    // A successful signup usually returns an 'id' or a 'success' key.
    if (response.isNotEmpty && !response.containsKey('id') && !response.containsKey('success')) {
      
      // Get the first error field name (e.g., 'email')
      String firstKey = response.keys.first;
      var errorData = response[firstKey];

      // Handle if the error is a List (e.g., ["Email already taken"])
      if (errorData is List && errorData.isNotEmpty) {
        errorMessage = errorData[0].toString();
      } else {
        errorMessage = errorData.toString();
      }

      CustomSnackbar.show(context, message: errorMessage!);
      
      isLoading = false;
      notifyListeners();
      return false;
    }

    firstNameController.clear();
    emailController.clear();
    lastNameController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    // 2. Success Case
    CustomSnackbar.show(context, message: "Account created successfully!");
    isLoading = false;
    notifyListeners();
    return true;

  } catch (e) {
    isLoading = false;
    errorMessage = "Something went wrong. Please try again.";
    notifyListeners();
    
    CustomSnackbar.show(context, message: errorMessage!);
    debugPrint("Signup Error: $e");
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

// Helper to make the field name look nice (e.g. email -> Email)
String _capitalize(String s) => s.isEmpty ? s : "${s[0].toUpperCase()}${s.substring(1)}".replaceAll('_', ' ');

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
