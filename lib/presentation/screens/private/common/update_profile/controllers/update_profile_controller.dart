import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  // State variables
  final currentPage = RxInt(0);
  final userName = RxString('');
  final userImage = RxString('');
  final userMobile = RxString('');

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    pageController.addListener(onPageChange);
  }

  void onPageChange() {
    final newPage = pageController.page?.round() ?? 0;
    if (currentPage.value != newPage) {
      currentPage.value = newPage;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void completeProfileUpdate() {
    // Save profile data
    Get.back();
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
