import 'package:get/get.dart';

import '../controllers/delete_screen_controller.dart';

class DeleteAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteScreenController>(() => DeleteScreenController());
  }
}