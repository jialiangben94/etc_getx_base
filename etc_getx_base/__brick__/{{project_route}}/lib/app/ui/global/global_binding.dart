import 'package:get/get.dart';

import 'package:{{project_route}}/app/ui/global/global_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}
