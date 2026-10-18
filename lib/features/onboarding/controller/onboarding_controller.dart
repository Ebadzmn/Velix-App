import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  void goToCreateAccount() {
    Get.toNamed(Routes.signup);
  }

  void goToLogin() {
    Get.toNamed(Routes.login);
  }
}
