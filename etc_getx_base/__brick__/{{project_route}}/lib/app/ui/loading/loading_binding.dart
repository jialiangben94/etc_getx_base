import 'package:{{project_route}}/app/ui/loading/loading_controller.dart';
import 'package:get/get.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController());
  }
}
