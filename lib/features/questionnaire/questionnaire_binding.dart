import 'package:get/get.dart';
import 'controller/questionnaire_controller.dart';

class QuestionnaireBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QuestionnaireController>(QuestionnaireController());
  }
}
