import 'package:get/get.dart';

class BetaProgramController extends GetxController {
  final isBankConnectionJoined = true.obs;
  final isInvestmentJoined = true.obs;
  final isVelixCardJoined = true.obs;

  void toggleBankConnection() {
    isBankConnectionJoined.value = !isBankConnectionJoined.value;
  }

  void toggleInvestment() {
    isInvestmentJoined.value = !isInvestmentJoined.value;
  }

  void toggleVelixCard() {
    isVelixCardJoined.value = !isVelixCardJoined.value;
  }
}
