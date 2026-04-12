import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/models/user_type.dart';
import '../../../../../../common/styles/app_colors.dart';
import '../controllers/update_profile_controller.dart';
import '../widgets/profile_info_widget.dart';
import '../widgets/mobile_number_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  final _controller = Get.find<UpdateProfileController>();

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // _controller.currentPage.listen((value) {

    // });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments as UserRole;
    final color = role == UserRole.customer
        ? AppColors.primaryPink
        : AppColors.primaryBlue;
    final bg = role == UserRole.customer
        ? AppColors.bgPink
        : AppColors.bgBlue;
    return GetBuilder<UpdateProfileController>(
      init: _controller,
      initState: (state) {
        _progressAnimationController.forward(
          from: _controller.currentPage.value * 0.5,
        );
      },
      builder: (controller) {
        return PopScope(
          canPop: controller.currentPage.value == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (controller.currentPage.value > 0) {
              controller.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Scaffold(
            backgroundColor: bg,
            body: SafeArea(
              child: Stack(
                children: [
                  // PageView for transitions
                  Positioned.fill(
                    child: PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        controller.currentPage.value = index;
                      },
                      children: [
                        // Page 1: Profile Info
                        ProfileInfoWidget(
                          userRole: role,
                          initialName: controller.userName.value,
                          initialImageUrl: controller.userImage.value,
                          onNext: () {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                        // Page 2: Mobile Number
                        MobileNumberWidget(
                          userRole: role,
                          initialMobile: controller.userMobile.value,
                          onPrevious: () {
                            controller.pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          onComplete: () {
                            controller.completeProfileUpdate();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Progress Indicator
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowPinkLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${controller.currentPage.value + 1}/2',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Progress Bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _progressAnimationController,
                      builder: (context, child) {
                        final targetProgress =
                            (controller.currentPage.value + 1) * 0.5;
                        final progress =
                            Tween<double>(
                              begin: 0,
                              end: targetProgress,
                            ).evaluate(
                              CurvedAnimation(
                                parent: _progressAnimationController,
                                curve: Curves.easeInOut,
                              ),
                            );
                        return LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withAlpha(77),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 3,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
