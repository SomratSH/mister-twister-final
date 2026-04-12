import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/change_password_controller.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChangePasswordProvider>();
    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textDark,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Welcome Back Title
              const Text(
                'Change Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),

              // Login Subtitle
              const Text(
                'Please enter your new password below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 32),

              // Form Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primaryPink.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowPinkLight,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      return _buildPasswordField(
                        controller: controller.passwordController,
                        obscurePassword: controller.obscurePassword.value,
                        onToggleObscurePassword: () {
                          controller.obscurePassword.value =
                              !controller.obscurePassword.value;
                        },
                      );
                    }),
                    const SizedBox(height: 24),

                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 600),
                      child: Obx(() {
                        return SizedBox(
                          height: controller.showConfirmPassword.value
                              ? null
                              : 0,
                          child: AnimatedSlide(
                            offset: controller.showConfirmPassword.value
                                ? Offset.zero
                                : const Offset(0, -0.2),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            child: AnimatedOpacity(
                              opacity: controller.showConfirmPassword.value
                                  ? 1.0
                                  : 0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Confirm Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Obx(() {
                                    return _buildPasswordField(
                                      controller:
                                          controller.confirmPasswordController,
                                      obscurePassword:
                                          controller.obscurePassword.value,
                                      onToggleObscurePassword: () {
                                        controller.obscurePassword.value =
                                            !controller.obscurePassword.value;
                                      },
                                    );
                                  }),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    // ...existing code...
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: AppColors.pinkGradient,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowPinkDark,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscurePassword,
    required Function() onToggleObscurePassword,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.primaryPink.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscurePassword,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrayLight,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.lock_rounded,
              color: AppColors.primaryPink,
              size: 20,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              onToggleObscurePassword();
            },
            child: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textGrayLight,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
