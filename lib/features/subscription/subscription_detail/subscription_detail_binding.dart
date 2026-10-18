import 'package:get/get.dart';
import 'controller/subscription_detail_controller.dart';

class SubscriptionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionDetailController>(() => SubscriptionDetailController());
  }
}
