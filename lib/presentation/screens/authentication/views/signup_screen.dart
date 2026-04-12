import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/signup_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../common/styles/app_colors.dart';
import '../../../../common/widgets/social_button.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SignupProvider>();
    return Scaffold(
      backgroundColor: AppColors.bgPink,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration/Icon
              Text('🍦', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 10),

              // Sign Up Subtitle
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
                      'First Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: controller.firstNameController,
                      hintText: 'Enter your first name',
                      icon: Icons.person,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Last Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: controller.lastNameController,
                      hintText: 'Enter your Last name',
                      icon: Icons.person,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    // Email Field
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: controller.phoneController,
                      hintText: 'Enter your phone',
                      icon: Icons.call,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    // Email Field
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPasswordField(
                      controller: controller.passwordController,
                      obscurePassword: controller.obscurePassword,
                      onToggleObscurePassword: () {
                        controller.obscurePassword =
                            !controller.obscurePassword;
                      },
                    ),

                    const SizedBox(height: 24),

                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      duration: const Duration(milliseconds: 600),
                      child: SizedBox(
                        height: controller.showConfirmPassword ? null : 0,
                        child: AnimatedSlide(
                          offset: controller.showConfirmPassword
                              ? Offset.zero
                              : const Offset(0, -0.2),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: controller.showConfirmPassword ? 1.0 : 0.0,
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

                                _buildPasswordField(
                                  controller:
                                      controller.confirmPasswordController,
                                  obscurePassword: controller.obscurePassword,
                                  onToggleObscurePassword: () {
                                    controller.obscurePassword =
                                        !controller.obscurePassword;
                                  },
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Signup Button
                    GestureDetector(
                      onTap: () async {
                        // OtpVerificationModal.show(
                        //   context,
                        //   email: controller.emailController.text,
                        //   onVerified: () {
                        //     // Get.offAllNamed(AppRoutes.userRole.path);
                        //   },
                        // );

                        context.push(RoutePath.selectRole);
                      },

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
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider with text
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.textGrayLight.withOpacity(0.3),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.textGrayLight.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SocialButton(
                            icon: 'assets/icons/google.svg',
                            label: 'Google',
                            onTap: () {},
                            bgColor: const Color(0xFFF3F4F6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SocialButton(
                            icon: 'assets/icons/apple.svg',
                            label: 'Apple',
                            onTap: () {},
                            bgColor: const Color(0xFFF3F4F6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign Up Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPink,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Get.offNamed(AppRoutes.login.path);
                                  context.go(RoutePath.login);
                                },
                            ),
                          ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
        keyboardType: keyboardType,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrayLight,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(icon, color: AppColors.primaryPink, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
