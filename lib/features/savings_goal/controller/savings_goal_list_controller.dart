import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import 'package:abbe_hossain/core/services/storage_service.dart';
import 'package:abbe_hossain/features/home/controller/home_controller.dart';
import '../models/savings_goal_item_model.dart';

class SavingsGoalListController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final goals = <SavingsGoalItemModel>[].obs;
  final userCurrency = 'KR'.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<StorageService>()) {
        userCurrency.value = Get.find<StorageService>().getUserCurrency();
      }
    } catch (_) {}
    fetchSavingsGoals();
  }

  Future<void> fetchSavingsGoals() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.savingsGoals);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data['data'];
        if (data != null) {
          List itemsRaw = [];
          if (data is Map && data['items'] is List) {
            itemsRaw = data['items'];
          } else if (data is List) {
            itemsRaw = data;
          }
          goals.value = itemsRaw.map((e) => SavingsGoalItemModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGoal({
    required String name,
    required double targetAmount,
    required double savedAmount,
  }) async {
    try {
      final payload = {
        'name': name,
        'target_amount': targetAmount,
        'saved_amount': savedAmount,
        'currency': userCurrency.value,
        'is_active': true,
      };

      final response = await _apiClient.post(
        ApiEndpoints.savingsGoals,
        data: payload,
      );

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        await fetchSavingsGoals();
        if (Get.isRegistered<HomeController>()) {
          final home = Get.find<HomeController>();
          home.fetchBudgetDashboard();
          home.fetchHomeDashboard();
          home.fetchAchievementsSummary();
        }
        Get.snackbar(
          'Goal Created 🎉',
          'Savings goal "$name" has been added successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not create savings goal. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> addSavingsAmount({
    required String goalId,
    required double additionalAmount,
  }) async {
    final goal = goals.firstWhereOrNull((g) => g.id == goalId);
    if (goal == null) return;

    final newSavedAmount = goal.savedAmount + additionalAmount;

    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.savingsGoals}/$goalId',
        data: {'saved_amount': newSavedAmount},
      );

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        await fetchSavingsGoals();
        if (Get.isRegistered<HomeController>()) {
          final home = Get.find<HomeController>();
          home.fetchBudgetDashboard();
          home.fetchHomeDashboard();
          home.fetchAchievementsSummary();
        }
        Get.snackbar(
          'Savings Updated 💰',
          'Added ${additionalAmount.toInt()} ${goal.currency} to "${goal.name}".',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Could not update savings goal.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      goals.removeWhere((g) => g.id == goalId);
      await _apiClient.delete('${ApiEndpoints.savingsGoals}/$goalId');
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        home.fetchBudgetDashboard();
        home.fetchHomeDashboard();
        home.fetchAchievementsSummary();
      }
    } catch (_) {}
  }
}
