import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  HomeBinding();
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}