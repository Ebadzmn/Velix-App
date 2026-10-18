import 'package:get/get.dart';
import 'controller/beta_program_controller.dart';

class BetaProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BetaProgramController>(() => BetaProgramController());
  }
}
