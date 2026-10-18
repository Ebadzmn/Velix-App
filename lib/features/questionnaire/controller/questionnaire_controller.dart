import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class QuestionStepData {
  final String icon;
  final String title;
  final String subtitle;
  final String prefix;
  final String hint;

  QuestionStepData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.prefix,
    required this.hint,
  });
}

class SubscriptionItem {
  final String icon;
  final String name;
  final RxDouble customPrice;
  final RxBool isSelected;

  SubscriptionItem({
    required this.icon,
    required this.name,
    required double defaultPrice,
    bool isSelected = false,
  })  : customPrice = defaultPrice.obs,
        isSelected = isSelected.obs;

  String formattedPrice(String currency) {
    final priceVal = customPrice.value;
    final formattedNum = priceVal % 1 == 0 ? priceVal.toInt().toString() : priceVal.toStringAsFixed(1);
    return '$formattedNum $currency';
  }
}

class FixedCostCategory {
  final String icon;
  final String name;
  final RxDouble amount;
  final RxString note;

  FixedCostCategory({
    required this.icon,
    required this.name,
    double amount = 0.0,
    String note = '',
  })  : amount = amount.obs,
        note = note.obs;
}

class SavingsGoalItem {
  final String icon;
  final String name;
  final RxBool isSelected;

  SavingsGoalItem({
    required this.icon,
    required this.name,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;
}

class QuestionnaireController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final currentStep = 1.obs;
  final totalSteps = 6;
  final userName = 'DF'.obs;
  final userCurrency = 'KR'.obs;
  final isReviewScreenShown = false.obs;
  final isSubmitting = false.obs;
  final previewRevision = 0.obs;

  final Map<int, TextEditingController> stepControllers = {};

  final RxList<QuestionStepData> steps = <QuestionStepData>[].obs;
  final RxList<SubscriptionItem> subscriptions = <SubscriptionItem>[].obs;

  final List<FixedCostCategory> fixedCosts = [
    FixedCostCategory(icon: '🏋️', name: 'Gym'),
    FixedCostCategory(icon: '🛡️', name: 'Insurance'),
    FixedCostCategory(icon: '🏠', name: 'Rent'),
    FixedCostCategory(icon: '📱', name: 'Phone'),
    FixedCostCategory(icon: '🌐', name: 'Internet'),
    FixedCostCategory(icon: '💳', name: 'Loan'),
    FixedCostCategory(icon: '🚌', name: 'Transport'),
    FixedCostCategory(icon: '❤️', name: 'Other'),
  ];

  final List<SavingsGoalItem> savingsGoals = [
    SavingsGoalItem(icon: '🏖️', name: 'Holiday', isSelected: true),
    SavingsGoalItem(icon: '🛡️', name: 'Emergency fund'),
    SavingsGoalItem(icon: '🚗', name: 'Car'),
    SavingsGoalItem(icon: '🏠', name: 'Residence'),
    SavingsGoalItem(icon: '💍', name: 'Wedding'),
    SavingsGoalItem(icon: '📦', name: 'Customized'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserContext();
    _initStepsAndSubscriptions();
    for (int i = 1; i <= totalSteps; i++) {
      stepControllers[i] = TextEditingController();
    }
  }

  void _initStepsAndSubscriptions() {
    final curr = userCurrency.value;
    steps.value = [
      QuestionStepData(
        icon: '💼',
        title: 'Your monthly salary',
        subtitle: 'How much do you earn per month after taxes?',
        prefix: curr,
        hint: 'e.g. 32,000',
      ),
      QuestionStepData(
        icon: '💰',
        title: 'Other income',
        subtitle: 'Freelance, rental income or other income?',
        prefix: curr,
        hint: '0',
      ),
      QuestionStepData(
        icon: '📱',
        title: 'Quick add subscription',
        subtitle: 'Tap to add common services you use',
        prefix: curr,
        hint: '0',
      ),
      QuestionStepData(
        icon: '🏠',
        title: 'Fixed monthly costs',
        subtitle: 'Add your personal monthly expenses',
        prefix: curr,
        hint: '0',
      ),
      QuestionStepData(
        icon: '🏦',
        title: 'Monthly savings',
        subtitle: 'How much do you want to save per month?',
        prefix: curr,
        hint: 'e.g. 2,000',
      ),
      QuestionStepData(
        icon: '🎯',
        title: 'Your savings goal',
        subtitle: 'What do you want to save for? (optional)',
        prefix: curr,
        hint: '0',
      ),
    ];

    subscriptions.value = [
      SubscriptionItem(icon: '🎬', name: 'Netflix', defaultPrice: 179),
      SubscriptionItem(icon: '🎵', name: 'Spotify', defaultPrice: 119),
      SubscriptionItem(icon: '✨', name: 'Disney+', defaultPrice: 89),
      SubscriptionItem(icon: '📦', name: 'Prime Video', defaultPrice: 59),
      SubscriptionItem(icon: '▶️', name: 'YouTube Premium', defaultPrice: 129),
      SubscriptionItem(icon: '🎶', name: 'Apple Music', defaultPrice: 119),
      SubscriptionItem(icon: '🔵', name: 'Google One', defaultPrice: 29),
      SubscriptionItem(icon: '📊', name: 'Microsoft 365', defaultPrice: 89),
      SubscriptionItem(icon: '📁', name: 'Dropbox', defaultPrice: 159),
    ];
  }

  void _loadUserContext() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        userCurrency.value = storage.getUserCurrency();
        final user = storage.getUser();
        if (user != null) {
          final first = user['firstName'] ?? '';
          final last = user['lastName'] ?? '';
          if (first.isNotEmpty || last.isNotEmpty) {
            userName.value = '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}'.toUpperCase();
          }
        }
      }
    } catch (_) {}
  }

  TextEditingController get currentController => stepControllers[currentStep.value]!;

  QuestionStepData get currentStepData => steps[currentStep.value - 1];

  void toggleSubscription(SubscriptionItem item) {
    item.isSelected.toggle();
  }

  void updateSubscriptionPrice(SubscriptionItem item, double newPrice) {
    item.customPrice.value = newPrice;
    item.isSelected.value = true;
  }

  void saveFixedCost(FixedCostCategory category, double amt, String noteVal) {
    category.amount.value = amt;
    category.note.value = noteVal;
  }

  void selectSavingsGoal(SavingsGoalItem selected) {
    for (var item in savingsGoals) {
      item.isSelected.value = (item == selected);
    }
  }

  void nextStep() {
    if (currentStep.value < totalSteps) {
      currentStep.value++;
    } else {
      showReviewScreen();
    }
  }

  void previousStep() {
    if (isReviewScreenShown.value) {
      isReviewScreenShown.value = false;
      return;
    }
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  void skip() {
    showReviewScreen();
  }

  void showReviewScreen() {
    isReviewScreenShown.value = true;
  }

  // Submit Questionnaire Financial Profile to Backend API and Navigate to Home
  Future<void> goToDashboard() async {
    isSubmitting.value = true;

    try {
      // 1. Monthly Salary (number)
      final rawSalaryText = stepControllers[1]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
      final num monthlySalary = num.tryParse(rawSalaryText) ?? 0;

      // 2. Other Income (number)
      final rawOtherText = stepControllers[2]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
      final num otherIncome = num.tryParse(rawOtherText) ?? 0;

      // 3. Subscriptions (Array<{ name: string, price: number, currency: string }>)
      final List<Map<String, dynamic>> selectedSubscriptions = subscriptions
          .where((sub) => sub.isSelected.value)
          .map((sub) => {
                'name': sub.name,
                'price': sub.customPrice.value,
                'currency': userCurrency.value,
              })
          .toList();

      // 4. Fixed Costs (Array<{ category: string, amount: number }>)
      final List<Map<String, dynamic>> enteredFixedCosts = fixedCosts
          .where((fc) => fc.amount.value > 0)
          .map((fc) => {
                'category': fc.name,
                'amount': fc.amount.value,
              })
          .toList();

      // 5. Monthly Savings (number)
      final rawSavingsText = stepControllers[5]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
      final num monthlySavings = num.tryParse(rawSavingsText) ?? 0;

      // 6. Savings Goal (string)
      final customGoalText = stepControllers[6]?.text.trim() ?? '';
      final String savingsGoal = customGoalText.isNotEmpty
          ? customGoalText
          : selectedSavingsGoalName;

      // Prepare Payload matching API Schema
      final Map<String, dynamic> payload = {
        'monthlySalary': monthlySalary,
        'otherIncome': otherIncome,
        'subscriptions': selectedSubscriptions,
        'fixedCosts': enteredFixedCosts,
        'monthlySavings': monthlySavings,
        'savingsGoal': savingsGoal,
      };

      final response = await _apiClient.post(
        ApiEndpoints.financialProfile,
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success 🎉',
          response.data?['message'] ?? 'Financial profile saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.home);
      } else {
        Get.snackbar(
          'Notice',
          response.data?['message'] ?? 'Profile updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF9482FF),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Get.offAllNamed(Routes.home);
      }
    } on DioException catch (e) {
      String errorMessage = 'Could not save financial profile. Proceeding to dashboard...';

      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          if (errorData['errorMessages'] != null &&
              errorData['errorMessages'] is List &&
              (errorData['errorMessages'] as List).isNotEmpty) {
            errorMessage = errorData['errorMessages'][0]['message'] ??
                errorData['message'] ??
                errorMessage;
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        }
      }

      Get.snackbar(
        'Warning',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );

      // Still navigate to dashboard so user is not blocked
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.offAllNamed(Routes.home);
    } finally {
      isSubmitting.value = false;
    }
  }

  // Calculated values for Financial Snapshot Card on Review Screen
  int get calculatedMonthlyIncome {
    previewRevision.value;
    final salary = double.tryParse(stepControllers[1]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '') ?? 0.0;
    final other = double.tryParse(stepControllers[2]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '') ?? 0.0;
    final total = salary + other;
    return total.toInt();
  }

  int get calculatedSubscriptionCost {
    previewRevision.value;
    int total = 0;
    for (var sub in subscriptions) {
      if (sub.isSelected.value) {
        total += sub.customPrice.value.toInt();
      }
    }
    return total;
  }

  int get calculatedFixedCost {
    previewRevision.value;
    return fixedCosts.fold<int>(0, (sum, cost) => sum + cost.amount.value.round());
  }

  int get calculatedMonthlySavings {
    previewRevision.value;
    final raw = stepControllers[5]?.text.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
    return (double.tryParse(raw) ?? 0).round();
  }

  int get calculatedMoneyLeft {
    final left = calculatedMonthlyIncome -
        calculatedSubscriptionCost -
        calculatedFixedCost -
        calculatedMonthlySavings;
    return left > 0 ? left : 0;
  }

  String get selectedSavingsGoalName {
    final selected = savingsGoals.firstWhere(
      (item) => item.isSelected.value,
      orElse: () => savingsGoals[0],
    );
    return selected.name == 'Holiday' ? 'Vacation' : selected.name;
  }

  @override
  void onClose() {
    for (var controller in stepControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
}
