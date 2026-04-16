import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/signup_controller.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/models/user_type.dart';
import '../../../../../../common/styles/app_colors.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../controllers/user_role_controller.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({super.key});

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen>
    with TickerProviderStateMixin {
  late AnimationController _borderAnimationController;

  @override
  void initState() {
    super.initState();
    _borderAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _borderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SignupProvider>();
    return Scaffold(
      backgroundColor: controller.selectedRole == UserRole.customer
          ? AppColors.bgPink
          : AppColors.bgBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Title
              Text(
                'Mister Twister',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: controller.selectedRole == UserRole.customer
                      ? AppColors.primaryPinkDark
                      : AppColors.primaryBlueDark,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Lobster',
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Choose your app interface',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  controller.selectRole(UserRole.customer);
                },
                child: _buildRoleCard(
                  context,
                  icon: '🍦',
                  title: 'Customer App',
                  description:
                      'Track nearby ice cream trucks, browser menu, and order your favorite treats!',
                  buttonText: 'Launch Customer App',
                  buttonColor: AppColors.primaryPink,
                  isSelected: controller.selectedRole == UserRole.customer,
                  borderAnimationController: _borderAnimationController,
                ),
              ),

              const SizedBox(height: 24),

              // Vendor App Card
              GestureDetector(
                onTap: () {
                  controller.selectRole(UserRole.driver);
                },
                child: _buildRoleCard(
                  context,
                  icon: '🚐',
                  title: 'Vendor App',
                  description:
                      'Manage your ice cream truck, accept order, and navigate customers.',
                  buttonText: 'Launch vendor App',
                  buttonColor: AppColors.primaryBlue,
                  isSelected: controller.selectedRole == UserRole.driver,
                  borderAnimationController: _borderAnimationController,
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
             GestureDetector(
  onTap: controller.isLoading 
      ? null // Disable tap while loading
      : () async {
          final status = await controller.signUp(context);
          if (status) {
            // Note: Since you handle the success snackbar in the provider 
            // usually, you can keep or remove this one.
            CustomSnackbar.show(context, message: "Signup successfully");
            context.go(RoutePath.login);
          }
        },
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      gradient: (controller.selectedRole == UserRole.customer
          ? AppColors.pinkGradient
          : AppColors.blueGradient),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: (controller.selectedRole == UserRole.customer
                  ? AppColors.primaryPink
                  : AppColors.primaryBlue)
              .withAlpha(76),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      // 🔥 Show loading indicator if isLoading is true
      child: controller.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required bool isSelected,
    required AnimationController borderAnimationController,
  }) {
    return AnimatedBuilder(
      animation: borderAnimationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: isSelected
                ? SweepGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      buttonColor,
                    ],
                    transform: GradientRotation(
                      borderAnimationController.value * 6.3,
                    ),
                  )
                : null,
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: AppColors.shadowPinkLight,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: buttonColor.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Box
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: buttonColor == AppColors.primaryPink
                        ? AppColors.pinkGradient
                        : AppColors.blueGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
