import 'package:get/get.dart';
import 'controller/insights_controller.dart';

class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(() => InsightsController());
  }
}
