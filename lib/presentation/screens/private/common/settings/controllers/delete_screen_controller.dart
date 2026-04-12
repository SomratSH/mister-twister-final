import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DeleteScreenController extends GetxController {
  late TextEditingController passwordController = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool agreedToDelete = false.obs;
  RxBool isLoading = false.obs;

  Future<void> proceedWithDeletion(BuildContext context) async {
    isLoading.value = true;

    try {
      // TODO: Implement actual account deletion API call
      // await controller.deleteAccount(
      //   password: _passwordController.text,
      // );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Get.back(); // Close confirmation dialog
        Get.snackbar(
          'Success',
          'Your account has been successfully deleted.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          onTap: (snack) {
            Get.back(); // Close screen after snackbar tap
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Get.snackbar(
          'Error',
          'Failed to delete account: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
