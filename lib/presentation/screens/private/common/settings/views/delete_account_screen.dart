import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/models/user_type.dart';
import '../../../../../../common/styles/app_colors.dart';
import '../controllers/delete_screen_controller.dart';

// ignore: must_be_immutable
class DeleteAccountScreen extends GetView<DeleteScreenController> {
  DeleteAccountScreen({super.key});

  // Get colors based on user role
  late Color _primaryColor;
  late Color _bgColor;
  late UserRole userRole = Get.arguments as UserRole;

  void _handleDeleteAccount(BuildContext context) async {
    if (!_validateInputs()) {
      return;
    }

    if (!controller.agreedToDelete.value) {
      Get.snackbar(
        'Error',
        'Please agree to delete your account',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _showDeleteConfirmationDialog(context);
  }

  bool _validateInputs() {
    final password = controller.passwordController.text.trim();

    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: _primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Confirm Deletion',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'This action cannot be undone. Your account and all associated data will be permanently deleted.',
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Buttons
                Column(
                  children: [
                    // Delete Button
                    GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : () => controller.proceedWithDeletion(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: userRole == UserRole.customer
                              ? AppColors.pinkGradient
                              : AppColors.blueGradient,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: controller.isLoading.value
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Yes, Delete My Account',
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

                    // Cancel Button
                    Obx(() {
                      return GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () => Get.back(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: _primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: !controller.isLoading.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userRole == UserRole.customer) {
      _primaryColor = AppColors.primaryPink;
      _bgColor = AppColors.bgPink;
    } else {
      _primaryColor = AppColors.primaryBlue;
      _bgColor = AppColors.bgBlue;
    }
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_rounded, color: _primaryColor, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Warning',
                            style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Deleting your account is permanent. All your data will be lost and cannot be recovered.',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Password Section
              Text(
                'Verify Your Identity',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(
                        color: AppColors.textGrayLight,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.obscurePassword.value =
                              !controller.obscurePassword.value;
                        },
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Checkbox for Agreement
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: controller.agreedToDelete.value,
                      onChanged: (value) {
                        controller.agreedToDelete.value = value ?? false;
                      },
                      activeColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.agreedToDelete.value =
                            !controller.agreedToDelete.value;
                      },
                      child: Text(
                        'I understand that deleting my account is permanent and all data will be lost.',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Delete Button
              GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : () => _handleDeleteAccount(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: userRole == UserRole.customer
                        ? AppColors.pinkGradient
                        : AppColors.blueGradient,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    return Center(
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
