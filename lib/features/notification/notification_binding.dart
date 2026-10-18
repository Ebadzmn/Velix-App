import 'package:get/get.dart';
import 'controller/notification_list_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationListController>(() => NotificationListController());
  }
}
