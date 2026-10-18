import 'package:get/get.dart';
import 'controller/savings_goal_list_controller.dart';

class SavingsGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavingsGoalListController>(() => SavingsGoalListController());
  }
}
