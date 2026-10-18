import 'package:get/get.dart';
import 'controller/new_subscription_controller.dart';

class NewSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewSubscriptionController>(() => NewSubscriptionController());
  }
}
